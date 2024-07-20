//
//  AIClassificationCard.swift
//  AIClassification
//
//  Created by 김영균 on 7/8/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Models
import OrderedCollections
import Services

@Reducer
public struct AIClassificationCard {
    @ObservableState
    public struct State: Equatable {
        fileprivate(set) var sections: OrderedDictionary<String, Folder>
        fileprivate(set) var selectedFolderId: String
        fileprivate(set) var scrollPage: Int
        fileprivate(set) var items: OrderedDictionary<String, [Card]> // key: folderId, value: cards

        public init(folders: [Folder], selectedFolderId: String) {
            sections = OrderedDictionary(uniqueKeysWithValues: folders.map { ($0.id, $0) })
            self.selectedFolderId = selectedFolderId
            scrollPage = 1
            items = [:]
        }
    }

    public enum Action {
        // MARK: View Action
        case onAppear
        case moveToAllItemsToFolderButtonTapped(section: Folder)
        case deleteButtonTapped(section: Folder, item: Card)
        case moveToFolderButtonTapped(section: Folder, item: Card)

        // MARK: Inner Business
        case fetchAIClassificationCards
        case fetchNextPageIfPossible(item: Card)
        case appendAIClassificationCards(cards: [Card])
        case sectionsChanged(sections: OrderedDictionary<String, Folder>)
        case itemsChanged(items: OrderedDictionary<String, [Card]>)

        case routeToHomeScreen
        case routeToFeedScreen(Folder)
    }

    public init() {}

    @Dependency(\.aiClassificationAPIClient) var aiClassificationAPIClient

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.fetchAIClassificationCards)

            case let .moveToAllItemsToFolderButtonTapped(section):
                return updateSectionsAndItems(
                    sections: state.sections,
                    items: state.items,
                    updateAPI: { try await aiClassificationAPIClient.patchPosts(suggestionFolderId: section.id, postId: nil) },
                    updateSections: { sections in
                        sections[section.id]?.postCount = 0
                        sections[Folder.ID.all]?.postCount = 0
                    },
                    updateItems: { items in
                        items[section.id] = []
                        items.removeAll { $0.value.isEmpty }
                    }
                )

            case let .deleteButtonTapped(section, item):
                return updateSectionsAndItems(
                    sections: state.sections,
                    items: state.items,
                    updateAPI: { try await aiClassificationAPIClient.deletePost(item.id) },
                    updateSections: { sections in
                        sections[section.id]?.postCount -= 1
                        sections[Folder.ID.all]?.postCount -= 1
                    },
                    updateItems: { items in
                        items[section.id]?.removeAll { $0.id == item.id }
                        items.removeAll { $0.value.isEmpty }
                    }
                )

            case let .moveToFolderButtonTapped(section, item):
                return updateSectionsAndItems(
                    sections: state.sections,
                    items: state.items,
                    updateAPI: { try await aiClassificationAPIClient.patchPosts(suggestionFolderId: section.id, postId: item.id) },
                    updateSections: { sections in
                        sections[section.id]?.postCount -= 1
                        sections[Folder.ID.all]?.postCount -= 1
                    },
                    updateItems: { items in
                        items[section.id]?.removeAll { $0.id == item.id }
                        items.removeAll { $0.value.isEmpty }
                    }
                )

            case .fetchAIClassificationCards:
                let folderId = state.selectedFolderId == Folder.ID.all ? nil : state.selectedFolderId
                return .run { send in
                    let posts = try await aiClassificationAPIClient.getPosts(folderId, 1)
                    await send(.appendAIClassificationCards(cards: posts))
                }

            case let .fetchNextPageIfPossible(item):
                guard let lastItem = state.items.values.last?.last, lastItem.id == item.id else { return .none }
                state.scrollPage += 1
                let folderId = state.selectedFolderId == Folder.ID.all ? nil : state.selectedFolderId
                return .run { [page = state.scrollPage] send in
                    let posts = try await aiClassificationAPIClient.getPosts(folderId, page)
                    await send(.appendAIClassificationCards(cards: posts))
                }

            case let .appendAIClassificationCards(cards):
                let groupedItems = Dictionary(grouping: cards) { $0.folderId }
                for item in groupedItems {
                    state.items[item.key, default: []].append(contentsOf: item.value)
                }
                return .none

            case let .sectionsChanged(sections):
                state.sections = sections
                return .none

            case let .itemsChanged(items):
                state.items = items
                return .none

            default:
                return .none
            }
        }
    }
}

extension AIClassificationCard {
    private func updateSectionsAndItems(
        sections: OrderedDictionary<String, Folder>,
        items: OrderedDictionary<String, [Card]>,
        updateAPI apiCall: @escaping () async throws -> Void,
        updateSections: (inout OrderedDictionary<String, Folder>) -> Void,
        updateItems: (inout OrderedDictionary<String, [Card]>) -> Void
    ) -> Effect<Action> {
        var updatedSections = sections
        var updatedItems = items

        updateSections(&updatedSections)
        updateItems(&updatedItems)

        return .run { [updatedSections, updatedItems] send in
            try await apiCall()
            await send(.sectionsChanged(sections: updatedSections))
            await send(.itemsChanged(items: updatedItems))
        } catch: { _, _ in
            // TODO: error handling
        }
    }
}
