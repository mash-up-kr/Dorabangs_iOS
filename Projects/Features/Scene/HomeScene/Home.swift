//
//  Home.swift
//  Home
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct Home {
    @ObservableState
    public struct State: Equatable {
        public var cards: [String] = ["카드0", "카드1", "카드2", "카드3", "카드4", "카드5", "카드6", "카드7", "카드8", "카드9", "카드10"]
        public static let initialState = State()
        public init() {}
    }

    public enum Action {
        case onAppear
        
        // MARK: Inner Business
        case fetchData
        
        // MARK: User Action
        case addLinkButtonTapped
        case bookMarkButtonTapped(Int)
        case showModalButtonTapped(Int)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .onAppear:
                return .none
                
            case .fetchData:
                for i in 0..<10 {
                    state.cards.append("카드 0\(i)")
                }
                return .none
                
            case .addLinkButtonTapped:
                // TODO: 링크 추가 버튼 탭 동작 구현
                return .none
                
            case .bookMarkButtonTapped(let index):
                // TODO: 카드 > 북마크 버튼 탭 동작 구현
                return .none
                
            case .showModalButtonTapped(let index):
                // TODO: 카드 > 모달 버튼 탭 동작 구현
                return .none
            }
        }
    }
}
