//
//  HomeCard.swift
//  Home
//
//  Created by 안상희 on 7/14/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Models
import OrderedCollections

@Reducer
public struct HomeCard {
    @ObservableState
    public struct State: Equatable {
        private(set) var tabs: [Folder]
        fileprivate(set) var selectedTabIndex: Int
        fileprivate(set) var scrollPage: Int
        fileprivate(set) var cards: [Card]

        public init(tabs: [Folder], selectedTabIndex: Int) {
            self.tabs = tabs
            self.selectedTabIndex = selectedTabIndex
            scrollPage = 0
            cards = []
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
        case fetchCards
        case addItems(items: [Card])
        case setScrollPage

        // MARK: User Action
        case bookMarkButtonTapped(Int)
        case showModalButtonTapped(Int)

        case routeToHomeScreen
        case routeToFeedScreen(Folder)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .selectedTabIndexChanged(selectedTabIndex):
                state.selectedTabIndex = selectedTabIndex
                state.cards.removeAll()
                return .none

            case .onAppear:
                return .send(.fetchCards)

            case let .fetchCards:
                // TODO: 데이터 받아오기
                state.cards = [
                    Card(
                        id: "",
                        folderId: "",
                        urlString: "https://naver.com",
                        thumbnail: nil,
                        title: "사건은 다가와, ah-oh, ayy 거세게 커져가, ah-oh, ayy",
                        description: "",
                        category: "질문은 계속돼, ah-oh, ayy 우린 어디서 왔나, oh, ayy 느껴 내 안에선, huh (su-su-su-supernova)",
                        createdAt: .now,
                        keywords: [
                            Keyword(
                                id: "",
                                name: "슈퍼노바"
                            ),
                            Keyword(
                                id: "",
                                name: "에스파"
                            ),
                            Keyword(
                                id: "",
                                name: "SM"
                            )
                        ]
                    )
                ]
                state.scrollPage += 1
                return .none

            case let .deleteButtonTapped(section, item):
//                state.sections[section]?.removeAll { $0.id == item.id }
//                state.sections = state.sections.compactMapValues { $0.isEmpty ? nil : $0 }
                return .none

            case let .addItems(items):
                let groupedItems = Dictionary(grouping: items) { $0.folderId }
                for tab in state.tabs {
//                    if let itemForTab = groupedItems[tab.id] {
//                        state.sections[tab, default: []].append(contentsOf: itemForTab)
//                    }
                }
                return .none

            default:
                return .none
            }
        }
    }
}
