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
            scrollPage = 0
            sections = [:]
        }
    }

    public enum Action {
        case selectedFolderChanged(Folder)

        // MARK: View Action
        case onAppear
        case moveToAllItemsToFolderButtonTapped(section: Folder)
        case deleteButtonTapped(section: Folder, item: Card)
        case moveToFolderButtonTapped(section: Folder, item: Card)

        // MARK: Inner Business
        case fetchCards(page: Int)
        case addItems(items: [Card])

        case routeToHomeScreen
        case routeToFeedScreen(Folder)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .selectedFolderChanged(selectedFolder):
                state.selectedFolder = selectedFolder
                state.sections.removeAll()
                return .none

            case .onAppear:
                return .send(.fetchCards(page: 0))

            case .fetchCards:
                return .none

            case let .deleteButtonTapped(section, item):
                state.items[section.id]?.removeAll { $0.id == item.id }
                state.items = state.items.compactMapValues { $0.isEmpty ? nil : $0 }
                return .none

            case let .addItems(items):
                let groupedItems = Dictionary(grouping: items) { $0.folderId }
                for folder in state.folders {
                    if let itemForTab = groupedItems[folder.id] {
                        state.sections[folder, default: []].append(contentsOf: itemForTab)
                    }
                }
                return .none

            default:
                return .none
            }
        }
    }
}
