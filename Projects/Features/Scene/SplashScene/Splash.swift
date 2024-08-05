//
//  Splash.swift
//  Splash
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Services

@Reducer
public struct Splash {
    @ObservableState
    public struct State: Equatable {
        var isAccessTokenSet: Bool = false
        var isAnimationFinished: Bool = false

        public init() {}
    }

    public enum Action {
        case onAppear
        case isAccessTokenSetChanged(Bool)
        case isAnimationFinishedChanged(Bool)

        case handleRouting
        case routeToOnboardingScreen
        case routeToTabCoordinatorScreen
    }

    public init() {}

    @Dependency(\.keychainClient) var keychainClient
    @Dependency(\.userAPIClient) var userAPIClient

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    try await handleUDIDAndAccessToken()
                    await send(.isAccessTokenSetChanged(true))
                } catch: { error, _ in
                    debugPrint(error.localizedDescription)
                }

            case let .isAccessTokenSetChanged(isAccessTokenSet):
                state.isAccessTokenSet = isAccessTokenSet
                return .none

            case let .isAnimationFinishedChanged(isAnimationFinished):
                state.isAnimationFinished = isAnimationFinished
                return .none

            case .handleRouting:
                if keychainClient.hasOnboarded {
                    return .send(.routeToTabCoordinatorScreen)
                } else {
                    return .send(.routeToOnboardingScreen)
                }

            case .routeToOnboardingScreen:
                return .none

            case .routeToTabCoordinatorScreen:
                return .none
            }
        }
    }
}

private extension Splash {
    func handleUDIDAndAccessToken() async throws {
        if let udid = keychainClient.udid {
            try await setAccessTokenIfNeeded(udid: udid)
        } else {
            let udid = UUID().uuidString
            keychainClient.setUDID(udid)
            try await setAccessTokenIfNeeded(udid: udid)
        }
    }

    func setAccessTokenIfNeeded(udid: String) async throws {
        let accessToken = try await userAPIClient.postUsers(udid)
        keychainClient.setAccessToken(accessToken)
    }
}
