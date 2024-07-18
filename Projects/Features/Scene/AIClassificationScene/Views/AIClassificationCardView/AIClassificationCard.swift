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
        private(set) var sections: OrderedDictionary<String, Folder>
        fileprivate(set) var selectedFolder: Folder
        fileprivate(set) var scrollPage: Int
        fileprivate(set) var items: OrderedDictionary<String, [Card]> // key: folderId, value: cards

        public init(folders: [Folder], selectedFolder: Folder) {
            sections = OrderedDictionary(uniqueKeysWithValues: folders.map { ($0.id, $0) })
            self.selectedFolder = selectedFolder
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

            case let .deleteButtonTapped(section, item):
                state.items[section.id]?.removeAll { $0.id == item.id }
                state.items = state.items.compactMapValues { $0.isEmpty ? nil : $0 }
                return .none

            case .fetchAIClassificationCards:
                let folderId = state.selectedFolder.id.isEmpty ? nil : state.selectedFolder.id
                return .run { send in
                    let posts = try await aiClassificationAPIClient.getPosts(folderId, 1)
                    await send(.appendAIClassificationCards(cards: posts))
                }

            case let .fetchNextPageIfPossible(item):
                guard let lastItem = state.items.values.last?.last, lastItem.id == item.id else { return .none }
                state.scrollPage += 1
                let folderId = state.selectedFolder.id.isEmpty ? nil : state.selectedFolder.id
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

            default:
                return .none
            }
        }
    }
}
