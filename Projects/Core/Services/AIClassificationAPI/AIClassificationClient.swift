//
//  AIClassificationClient.swift
//  Services
//
//  Created by 김영균 on 7/18/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Dependencies
import DependenciesMacros
import Foundation
import Models

@DependencyClient
public struct AIClassificationAPIClient {
    public var getFolders: @Sendable () async throws -> (totalCounts: Int, folders: [Folder])
}

public extension DependencyValues {
    var aiClassificationAPIClient: AIClassificationAPIClient {
        get { self[AIClassificationAPIClient.self] }
        set { self[AIClassificationAPIClient.self] = newValue }
    }
}

extension AIClassificationAPIClient: DependencyKey {
    public static var liveValue: AIClassificationAPIClient = Self(
        getFolders: {
            let api = AIClassificationAPI.getFolders
            let responseDTO: GetAIClassificationFolderResponseDTO = try await Provider().request(api)
            return (totalCounts: responseDTO.totalCounts, folders: responseDTO.list.map(\.toDomain))
        }
    )
}
