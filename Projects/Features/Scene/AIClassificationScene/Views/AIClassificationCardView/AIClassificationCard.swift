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
        /// 폴더 ID와 폴더를 매핑하는 딕셔너리
        fileprivate(set) var sections: OrderedDictionary<String, Folder>
        /// 현재 선택된 폴더의 ID
        fileprivate(set) var selectedFolderId: String
        /// 현재 페이지 정보
        fileprivate(set) var pageModel: AIClassificationCardPageModel
        /// 폴더 ID와 카드 목록을 매핑하는 딕셔너리
        fileprivate(set) var items: OrderedDictionary<String, [Card]>

        public init(
            folders: [Folder],
            selectedFolderId: String,
            cardList: CardListModel
        ) {
            let sections = OrderedDictionary(uniqueKeysWithValues: folders.map { ($0.id, $0) })
            self.sections = sections
            self.selectedFolderId = selectedFolderId
            pageModel = AIClassificationCardPageModel(hasNext: cardList.hasNext, currentPage: 1)
            let groupedItems = Dictionary(grouping: cardList.cards) { $0.folderId }
            items = OrderedDictionary(uniqueKeysWithValues: sections.compactMap { section in
                guard let cards = groupedItems[section.key] else { return nil }
                return (section.key, cards)
            })
        }
    }

    public enum Action {
        // MARK: View Actions
        /// 특정 섹션에 포함된 모든 분류 카드를 추천된 폴더로 이동시키는 버튼이 눌릴 때 발생합니다.
        case moveToAllItemsToFolderButtonTapped(section: Folder)
        /// 특저 섹션에 포함된 분류 카드에 대해 삭제 버튼이 눌릴 때 발생합니다.
        case deleteButtonTapped(section: Folder, item: Card)
        /// 특정 섹션에 포함된 분류 카드를 추천된 폴더로 이동시키는 버튼이 눌릴 때 발생합니다.
        case moveToFolderButtonTapped(section: Folder, item: Card)

        // MARK: Inner Business Actions
        /// 가능하면 다음 페이지의 카드를 가져옵니다.
        case fetchNextPageIfPossible(item: Card)
        /// 현재 항목에 AI 분류 카드 목록을 추가합니다.
        case appendAIClassificationCards(cards: [Card])
        /// 섹션이 변경되었을 때 발생합니다.
        case sectionsChanged(sections: OrderedDictionary<String, Folder>)
        /// 항목이 변경되었을 때 발생합니다.
        case itemsChanged(items: OrderedDictionary<String, [Card]>)
        /// 페이지 모델이 변경되었을 때 발생합니다.
        case pageModelChanged(pageModel: AIClassificationCardPageModel)

        // MARK: Navigation Actions
        /// 홈 화면으로 이동합니다.
        case routeToHomeScreen
        /// 특정 폴더의 피드 화면으로 이동합니다.
        case routeToFeedScreen(Folder)
    }

    public init() {}

    @Dependency(\.aiClassificationAPIClient) var aiClassificationAPIClient

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .moveToAllItemsToFolderButtonTapped(section):
                return updateSectionsAndItems(
                    sections: state.sections,
                    items: state.items,
                    updateAPI: { try await aiClassificationAPIClient.patchAllPost(suggestionFolderId: section.id) },
                    updateSections: { sections in
                        let deletedPostCount = sections[section.id]?.postCount
                        sections[section.id]?.postCount = 0
                        sections[Folder.ID.all]?.postCount -= deletedPostCount ?? 0
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
                    updateAPI: { try await aiClassificationAPIClient.patchPost(suggestionFolderId: section.id, postId: item.id) },
                    updateSections: { sections in
                        sections[section.id]?.postCount -= 1
                        sections[Folder.ID.all]?.postCount -= 1
                    },
                    updateItems: { items in
                        items[section.id]?.removeAll { $0.id == item.id }
                        items.removeAll { $0.value.isEmpty }
                    }
                )

            case let .fetchNextPageIfPossible(item):
                guard state.pageModel.hasNext, let lastItem = state.items.values.last?.last, lastItem.id == item.id else { return .none }
                state.pageModel.currentPage += 1
                let folderId = state.selectedFolderId == Folder.ID.all ? nil : state.selectedFolderId
                return .run { [currentPage = state.pageModel.currentPage] send in
                    let cardModel = try await aiClassificationAPIClient.getPosts(folderId, currentPage)
                    await send(.pageModelChanged(pageModel: AIClassificationCardPageModel(hasNext: cardModel.hasNext, currentPage: currentPage)))
                    await send(.appendAIClassificationCards(cards: cardModel.cards))
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

            case let .pageModelChanged(pageModel):
                state.pageModel = pageModel
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
