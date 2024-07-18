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
    public var getPosts: @Sendable (_ folderId: String?, _ page: Int) async throws -> [Card]
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
        },
        getPosts: { folderId, page in
            let api = AIClassificationAPI.getPosts(folderId: folderId, page: page)
            let responseDTO: GetAIClassificationPostsResponseDTO = try await Provider().request(api)
            return responseDTO.list.compactMap { dto in
                if let suggestionFolderId = dto.folderId {
                    Card(
                        id: dto.postId,
                        folderId: suggestionFolderId,
                        urlString: dto.url,
                        title: dto.title,
                        description: dto.description,
                        createdAt: ISO8601DateFormatter().date(from: dto.createdAt) ?? .now,
                        keywords: dto.aiClassification.keywords.map { Keyword(id: UUID().uuidString, name: $0) }
                    )
                } else if let folderId {
                    Card(
                        id: dto.postId,
                        folderId: folderId,
                        urlString: dto.url,
                        title: dto.title,
                        description: dto.description,
                        createdAt: ISO8601DateFormatter().date(from: dto.createdAt) ?? .now,
                        keywords: dto.aiClassification.keywords.map { Keyword(id: UUID().uuidString, name: $0) }
                    )
                } else {
                    nil
                }
            }
        }
    )
}
