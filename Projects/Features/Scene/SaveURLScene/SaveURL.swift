//
//  SaveURL.swift
//  SaveURL
//
//  Created by 김영균 on 6/29/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Models
import Services

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
        case setIsTextFieldWarned(Bool)
        case navigateToSelectFolder(saveURL: URL)
    }

    public init() {}

    @Dependency(\.urlValidatorClient) var urlValidatorClient

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none

            case let .urlStringChanged(urlString):
                state.urlString = urlString
                state.isTextFieldWarned = false
                state.isSaveButtonDisabled = urlString.isEmpty
                return .none

            case .saveButtonTapped:
                return .run { [urlString = state.urlString] send in
                    if let url = URL(string: urlString), let validURL = await urlValidatorClient.validateURL(url) {
                        await send(.navigateToSelectFolder(saveURL: validURL))
                    } else {
                        await send(.setIsTextFieldWarned(true))
                    }
                }

            case let .setIsTextFieldWarned(isWarned):
                state.isTextFieldWarned = isWarned
                state.isSaveButtonDisabled = true
                return .none

            default:
                return .none
            }
        }
    }
}
