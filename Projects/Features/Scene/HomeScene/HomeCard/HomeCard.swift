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

        // MARK: User Action
        case bookMarkButtonTapped(Int)
        case showModalButtonTapped(Int)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.fetchCards)

            case .fetchCards:
                // TODO: 데이터 받아오기
                state.scrollPage += 1
                return .none

            default:
                return .none
            }
        }
    }
}
