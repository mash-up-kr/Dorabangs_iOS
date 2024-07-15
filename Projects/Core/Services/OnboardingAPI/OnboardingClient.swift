//
//  OnboardingClient.swift
//  Services
//
//  Created by 김영균 on 7/15/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Dependencies
import DependenciesMacros
import Foundation

// MARK: - Interface
public struct OnboardingClient {
    public var getKeywords: @Sendable () async throws -> [String]
}

public extension DependencyValues {
    var onboardingClient: OnboardingClient {
        get { self[OnboardingClient.self] }
        set { self[OnboardingClient.self] = newValue }
    }
}

// MARK: - Live
extension OnboardingClient: DependencyKey {
    public static var liveValue: OnboardingClient = Self(
        getKeywords: {
            let api = OnboardingAPI.getKeywords
            return try await Provider().request(api)
        }
    )
}
