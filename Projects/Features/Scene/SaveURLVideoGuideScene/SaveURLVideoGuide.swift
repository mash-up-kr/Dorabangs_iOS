//
//  SaveURLVideoGuide.swift
//  SaveURLVideoGuide
//
//  Created by 김영균 on 7/24/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct SaveURLVideoGuide {
    @ObservableState
    public struct State: Equatable {
        public static let initialState = State()
        var isPresented: Bool = false
    }

    public enum Action {
        // MARK: View Action
        case onAppear
        case backButtonTapped
        case settingButtonTapped

        // MARK: Inner Business
        case isPresentedChanged(Bool)

        // MARK: Navigation Action
        case routeToPreviousScreen
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none

            case .backButtonTapped:
                return .send(.routeToPreviousScreen)

            case .settingButtonTapped:
                state.isPresented = true
                return .none

            case let .isPresentedChanged(isPresented):
                state.isPresented = isPresented
                return .none

            case .routeToPreviousScreen:
                return .none
            }
        }
    }
}
