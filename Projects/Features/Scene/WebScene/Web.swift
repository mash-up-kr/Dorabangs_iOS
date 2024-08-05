//
//  Web.swift
//  Web
//
//  Created by 김영균 on 7/27/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct Web {
    @ObservableState
    public struct State: Equatable {
        var url: URL

        public init(url: URL) {
            self.url = url
        }
    }

    public enum Action {
        case backButtonTapped
        case routeToPreviousScreen
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .backButtonTapped:
                .send(.routeToPreviousScreen)

            default:
                .none
            }
        }
    }
}
