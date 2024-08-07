//
//  UserAPIClient.swift
//  Services
//
//  Created by 김영균 on 7/9/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct UserAPIClient: Sendable {
    public var postUsers: @Sendable (_ deviceToken: String) async throws -> String
}

public extension DependencyValues {
    var userAPIClient: UserAPIClient {
        get { self[UserAPIClient.self] }
        set { self[UserAPIClient.self] = newValue }
    }
}

extension UserAPIClient: DependencyKey {
    public static var liveValue: UserAPIClient = .init(
        postUsers: { deviceToken in
            let api = UserAPI.postUsers(deviceToken: deviceToken)
            let responseDTO: PostUserResponseDTO = try await Provider().request(api)
            return responseDTO.accessToken
        }
    )
}
