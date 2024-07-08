//
//  Feed.swift
//  Home
//
//  Created by 박소현 on 6/29/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct Feed {
    @ObservableState
    public struct State: Equatable {
        public var cards: [String] = ["카드0", "카드1", "카드2", "카드3", "카드4", "카드5", "카드6", "카드7", "카드8", "카드9", "카드10"]
        public var title: String
        public init(title: String) {
            self.title = title
        }
    }

    public enum Action {
        case onAppear
        case backButtonTapped
        case routeToPreviousScreen

        // MARK: Inner Business
        case fetchData

        // MARK: User Action
        case tapMore
        case tapAllType
        case tapUnreadType
        case tapSortLatest
        case tapSortPast

        case bookMarkButtonTapped(Int)
        case showModalButtonTapped(Int)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .backButtonTapped:
                return .send(.routeToPreviousScreen)
            case .fetchData:
                for i in 0 ..< 10 {
                    state.cards.append("카드 0\(i)")
                }
                return .none
            case .tapMore:
                return .none
            case .tapSortLatest:
                return .none
            case .tapSortPast:
                return .none
            case let .bookMarkButtonTapped(index):
                // TODO: 카드 > 북마크 버튼 탭 동작 구현
                return .none
            case let .showModalButtonTapped(index):
                // TODO: 카드 > 모달 버튼 탭 동작 구현
                return .none
            default:
                return .none
            }
        }
    }
}
