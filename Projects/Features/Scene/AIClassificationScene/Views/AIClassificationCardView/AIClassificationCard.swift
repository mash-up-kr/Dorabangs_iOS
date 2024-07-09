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
        private(set) var tabs: [Folder]
        fileprivate(set) var selectedTabIndex: Int
        fileprivate(set) var scrollPage: Int
        fileprivate(set) var sections: OrderedDictionary<Folder, [Card]>

        public init(tabs: [Folder], selectedTabIndex: Int) {
            self.tabs = tabs
            self.selectedTabIndex = selectedTabIndex
            scrollPage = 0
            sections = [:]
        }
    }

    public enum Action {
        case selectedTabIndexChanged(Int)

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
            case let .selectedTabIndexChanged(selectedTabIndex):
                state.selectedTabIndex = selectedTabIndex
                state.sections.removeAll()
                return .none

            case .onAppear:
                return .send(.fetchCards(page: 0))

            case .fetchCards:
                return .none

            case let .deleteButtonTapped(section, item):
                state.sections[section]?.removeAll { $0.id == item.id }
                state.sections = state.sections.compactMapValues { $0.isEmpty ? nil : $0 }
                return .none

            case let .addItems(items):
                let groupedItems = Dictionary(grouping: items) { $0.folderId }
                for tab in state.tabs {
                    if let itemForTab = groupedItems[tab.id] {
                        state.sections[tab, default: []].append(contentsOf: itemForTab)
                    }
                }
                return .none

            default:
                return .none
            }
        }
    }
}
