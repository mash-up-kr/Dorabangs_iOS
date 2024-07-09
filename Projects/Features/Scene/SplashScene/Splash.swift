//
//  Splash.swift
//  Splash
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Services
import UIKit

@Reducer
public struct Splash {
    @ObservableState
    public struct State: Equatable {
        public init() {}
    }

    public enum Action {
        case onAppear
        case routeToOnboardingScreen
        case routeToTabCoordinatorScreen
    }

    public init() {}

    @Dependency(\.keychainClient) var keychainClient
    @Dependency(\.userAPIClient) var userAPIClient

    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .onAppear:
                .run { _ in
                    try await handleUDIDAndAccessToken()
                } catch: { error, _ in
                    debugPrint(error.localizedDescription)
                }

            case .routeToOnboardingScreen:
                .none

            case .routeToTabCoordinatorScreen:
                .none
            }
        }
    }
}

private extension Splash {
    func handleUDIDAndAccessToken() async throws {
        if let udid = keychainClient.udid {
            try await setAccessTokenIfNeeded(udid: udid)
        } else {
            if let udid = await UIDevice.current.identifierForVendor?.uuidString {
                keychainClient.setUDID(udid)
                try await setAccessTokenIfNeeded(udid: udid)
            }
        }
    }

    func setAccessTokenIfNeeded(udid: String) async throws {
        let accessToken = try await userAPIClient.postUsers(udid)
        keychainClient.setAccessToken(accessToken)
    }
}
