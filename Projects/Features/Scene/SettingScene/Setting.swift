//
//  Setting.swift
//  Setting
//
//  Created by 김영균 on 7/23/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Services

@Reducer
public struct Setting {
    @ObservableState
    public struct State: Equatable {
        public static let initialState = State()
        var deviceID: String?
    }

    public enum Action {
        case onAppear
        case reset
        case routeToPreviousScreen
        case routeToSplashScreen
    }

    public init() {}

    @Dependency(\.keychainClient) var keyChainClient

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.deviceID = keyChainClient.udid
                return .none

            case .reset:
                keyChainClient.remove("udid")
                keyChainClient.remove("accessToken")
                keyChainClient.remove("hasOnboarded")
                return .send(.routeToSplashScreen)

            default:
                return .none
            }
        }
    }
}
