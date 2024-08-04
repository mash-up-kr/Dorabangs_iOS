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
import Services

@Reducer
public struct HomeCard {
    @ObservableState
    public struct State: Equatable {
        var page: Int
        var cards: [Card]
        var fetchedAllCards: Bool = false
        var summarizingCardIdList: [String] = []
        var cardDictionary: [String: Card] = [:]

        public init(cards: [Card]) {
            page = 1
            self.cards = cards
        }
    }

    public enum Action {
        // MARK: View Action
        case onAppear

        // MARK: Inner Business
        case updateCard(Card)
        case updatePage
        case fetchCards(Int)
        case addItems(items: [Card])
        case setFetchedAllCardsStatus(Bool)
        case setPage
        case fetchSummarizingCardIdList([String])
        case setSummarizingCardIdList([String])
        case itemsChanged(items: [Card])

        // MARK: User Action
        case cardTapped(item: Card)
        case bookMarkButtonTapped(postId: String, isFavorite: Bool)
        case showModalButtonTapped(postId: String, folderId: String)
    }

    public init() {}

    @Dependency(\.mainQueue) var mainQueue
    @Dependency(\.postAPIClient) var postAPIClient

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none

            case let .updateCard(card):
                for index in 0 ..< state.cards.count {
                    if state.cards[index].id == card.id {
                        state.cards[index] = card
                    }
                }
                return .none

            case .updatePage:
                state.page += 1
                return .send(.fetchCards(state.page))

            case let .fetchCards(page):
                return .none

            case let .addItems(items):
                state.cards.append(contentsOf: items)
                return .none

            case let .setFetchedAllCardsStatus(fetchedAllCards):
                state.fetchedAllCards = fetchedAllCards
                return .none

            case let .fetchSummarizingCardIdList(cardIdList):
                return .run { send in
                    if #available(iOS 16.0, *) {
                        try await Task.sleep(for: .seconds(8))
                    } else {
                        try await Task.sleep(nanoseconds: 8 * 1_000_000_000)
                    }

                    let cardDictList = try await fetchSummarizingCardIdList(cardIdList, send: send)
                    for card in cardDictList {
                        await send(.updateCard(card.value))
                    }
                }

            case let .setSummarizingCardIdList(cardIdList):
                state.summarizingCardIdList = cardIdList
                return .send(.fetchSummarizingCardIdList(cardIdList))

            case let .bookMarkButtonTapped(postId, isFavorite):
                for index in 0 ..< state.cards.count {
                    if state.cards[index].id == postId {
                        state.cards[index].isFavorite = isFavorite
                    }
                }
                return .run { _ in
                    try await postAPIClient.isFavoritePost(postId, isFavorite)
                }

            case let .showModalButtonTapped(id):
                return .none

            default:
                return .none
            }
        }
    }
}

extension HomeCard {
    private func handlePost(postId: String) async throws -> Card {
        try await postAPIClient.getPost(postId: postId)
    }

    private func fetchSummarizingCardIdList(_ cardIdList: [String], send _: Send<HomeCard.Action>) async throws -> [String: Card] {
        var cardDict: [String: Card] = [:]
        try await withThrowingTaskGroup(of: (String, Card).self) { group in
            for id in cardIdList {
                group.addTask {
                    try await (id, fetchOneCard(postId: id))
                }
            }

            for try await (id, card) in group {
                cardDict[id] = card
            }
        }
        return cardDict
    }

    private func fetchOneCard(postId: String) async throws -> Card {
        async let cardResponse = try postAPIClient.getPost(postId: postId)
        let card = try await cardResponse
        return card
    }
}
