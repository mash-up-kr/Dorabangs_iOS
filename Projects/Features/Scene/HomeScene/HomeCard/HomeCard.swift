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

        public init(cards: [Card]) {
            page = 1
            self.cards = cards
        }
    }

    public enum Action {
        // MARK: View Action
        case onAppear

        // MARK: Inner Business
        case updatePage
        case fetchCards(Int)
        case addItems(items: [Card])
        case setFetchedAllCardsStatus(Bool)
        case setPage

        case itemsChanged(items: [Card])

        // MARK: User Action
        case cardTapped(item: Card)
        case bookMarkButtonTapped(postId: String, isFavorite: Bool)
        case showModalButtonTapped(postId: String, folderId: String)
    }

    public init() {}

    @Dependency(\.postAPIClient) var postAPIClient

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none

            case .updatePage:
                state.page += 1
                return .send(.fetchCards(state.page))

            case let .fetchCards(page):
                return .none

            case let .setFetchedAllCardsStatus(fetchedAllCards):
                state.fetchedAllCards = fetchedAllCards
                return .none

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
