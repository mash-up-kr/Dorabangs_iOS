//
//  AISummary.swift
//  AISummary
//
//  Created by 김영균 on 9/21/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Models

@Reducer
public struct AISummary {
    @ObservableState
    public struct State: Equatable {
        var aiSummary: String?
        var tags: [String]

        public init(aiSummary: String?, tags: [String]) {
            self.aiSummary = aiSummary
            self.tags = tags
        }
    }

    public enum Action {
        case closeButtonTapped
        case backButtonTapped
        case routeToPreviousScreen
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .backButtonTapped:
                .send(.routeToPreviousScreen)

            case .closeButtonTapped:
                .send(.routeToPreviousScreen)

            default:
                .none
            }
        }
    }
}
