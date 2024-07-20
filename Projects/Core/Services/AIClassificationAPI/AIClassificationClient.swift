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
    public var getPosts: @Sendable (_ folderId: String?, _ page: Int) async throws -> CardListModel
    public var deletePost: @Sendable (_ postId: String) async throws -> Void
    public var patchPosts: @Sendable (_ suggestionFolderId: String, _ postId: String?) async throws -> Void
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
            let cards = mapToCards(from: responseDTO, with: folderId)
            return CardListModel(hasNext: responseDTO.metadata.hasNext, total: responseDTO.metadata.total, cards: cards)
        },
        deletePost: { postId in
            let api = AIClassificationAPI.deletePost(postId: postId)
            let responseDTO: EmptyResponseDTO = try await Provider().request(api)
        },
        patchPosts: { suggestionFolderId, postId in
            let api = AIClassificationAPI.patchPosts(suggestionFolderId: suggestionFolderId, postId: postId)
            let responseDTO: EmptyResponseDTO = try await Provider().request(api)
        }
    )

    static func mapToCards(from dto: GetAIClassificationPostsResponseDTO, with folderId: String?) -> [Card] {
        dto.list.compactMap { dto in
            if let suggestionFolderId = dto.folderId {
                Card(
                    id: dto.postId,
                    folderId: suggestionFolderId,
                    urlString: dto.url,
                    title: dto.title,
                    description: dto.description,
                    createdAt: ISO8601DateFormatter().date(from: dto.createdAt) ?? .now,
                    keywords: dto.keywords.map { Keyword(id: UUID().uuidString, name: $0) }
                )
            } else if let folderId {
                Card(
                    id: dto.postId,
                    folderId: folderId,
                    urlString: dto.url,
                    title: dto.title,
                    description: dto.description,
                    createdAt: ISO8601DateFormatter().date(from: dto.createdAt) ?? .now,
                    keywords: dto.keywords.map { Keyword(id: UUID().uuidString, name: $0) }
                )
            } else {
                nil
            }
        }
    }
}
