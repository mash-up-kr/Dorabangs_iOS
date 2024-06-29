//
//  SaveURL.swift
//  SaveURL
//
//  Created by 김영균 on 6/29/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct SaveURL {
    @ObservableState
    public struct State: Equatable {
        public static let initialState = State(urlString: "")
        var urlString: String
        var isTextFieldWarned: Bool = false
        var isSaveButtonDisabled: Bool = true

        public init(urlString: String) {
            self.urlString = urlString
        }
    }

    public enum Action {
        case onAppear
        case backButtonTapped
        case urlStringChanged(String)
        case saveButtonTapped
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none

            case let .urlStringChanged(urlString):
                state.urlString = urlString
                return .none

            default:
                return .none
            }
        }
    }
}
