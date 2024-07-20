//
//  LinkAPIClient.swift
//  Services
//
//  Created by 박소현 on 7/20/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Dependencies
import DependenciesMacros
import Foundation
import Models

@DependencyClient
public struct LinkAPIClient {
    public var getValidation: @Sendable (_ link: String) async throws -> Bool
}

public extension DependencyValues {
    var linkAPIClient: LinkAPIClient {
        get { self[LinkAPIClient.self] }
        set { self[LinkAPIClient.self] = newValue }
    }
}

extension LinkAPIClient: DependencyKey {
    public static var liveValue: LinkAPIClient = .init(
        getValidation: { link in
            let api = LinkAPI.getValidation(link: link)
            let responseDTO: GetLinkValidationResponseDTO = try await Provider().request(api)
            return responseDTO.isValidate
        }
    )
}
