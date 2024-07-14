//
//  AIClassification.swift
//  AIClassification
//
//  Created by 김영균 on 7/7/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Models

@Reducer
public struct AIClassification {
    @ObservableState
    public struct State: Equatable {
        public static let initialState = State()
        var tabs: AIClassificationTab.State?
        var cards: AIClassificationCard.State?

        public init() {}
    }

    public enum Action {
        case onAppear
        case backButtonTapped

        case routeToHomeScreen
        case routeToFeedScreen(feedID: String)

        case tabs(AIClassificationTab.Action)
        case cards(AIClassificationCard.Action)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let tabs = [Folder(id: "A", name: "전체", type: .all, postCount: 0)]
                // TODO: fetch Tabs
                state.tabs = AIClassificationTab.State(tabs: tabs)
                // TODO: fetch Cards
                state.cards = AIClassificationCard.State(tabs: tabs, selectedTabIndex: 0)
                return .none

            case .backButtonTapped:
                return .send(.routeToHomeScreen)

            case let .tabs(.tabSelected(index)):
                guard var cardState = state.cards else { return .none }
                return AIClassificationCard()
                    .reduce(into: &cardState, action: .selectedTabIndexChanged(index))
                    .map(Action.cards)

            default:
                return .none
            }
        }
        .ifLet(\.tabs, action: \.tabs) {
            AIClassificationTab()
        }
        .ifLet(\.cards, action: \.cards) {
            AIClassificationCard()
        }
    }
}
