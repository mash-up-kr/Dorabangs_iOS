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
        fileprivate(set) var scrollPage: Int
        fileprivate(set) var cards: [Card]

        public init(cards: [Card]) {
            scrollPage = 0
            self.cards = cards
        }
    }

    public enum Action {
        // MARK: View Action
        case onAppear

        // MARK: Inner Business
        case fetchCards
        case addItems(items: [Card])
        case setScrollPage
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
                return .send(.fetchCards)

            case .fetchCards:
                // TODO: 데이터 받아오기
                state.scrollPage += 1
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

// private extension HomeCard {
//    private func handleFavoritePost(cardState _: inout State, postId: String, send _: Send<HomeCard.Action>) async throws {
//        try await postAPIClient.isFavoritePost(postId, isFavorite)
//    }
// }
