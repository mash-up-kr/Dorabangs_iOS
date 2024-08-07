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
public struct AIClassificationAPIClient: Sendable {
    public var getFolders: @Sendable () async throws -> (totalCounts: Int, folders: [Folder])
    public var getPosts: @Sendable (_ folderId: String?, _ page: Int) async throws -> CardListModel
    public var getAIClassificationCount: @Sendable () async throws -> Int
    public var deletePost: @Sendable (_ postId: String) async throws -> Void
    public var patchAllPost: @Sendable (_ suggestionFolderId: String) async throws -> Void
    public var patchPost: @Sendable (_ suggestionFolderId: String, _ postId: String) async throws -> Void
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
            let cards = responseDTO.list.map(\.toDomain)
            return CardListModel(hasNext: responseDTO.metadata.hasNext, total: responseDTO.metadata.total, cards: cards)
        },
        getAIClassificationCount: {
            let api = AIClassificationAPI.getAIClassificationCount
            let count: Int = try await Provider().request(api)
            return count
        },
        deletePost: { postId in
            let api = AIClassificationAPI.deletePost(postId: postId)
            let responseDTO: EmptyResponseDTO = try await Provider().request(api)
        },
        patchAllPost: { suggestionFolderId in
            let api = AIClassificationAPI.patchAllPost(suggestionFolderId: suggestionFolderId)
            let responseDTO: EmptyResponseDTO = try await Provider().request(api)
        },
        patchPost: { suggestionFolderId, postId in
            let api = AIClassificationAPI.patchPost(suggestionFolderId: suggestionFolderId, postId: postId)
            let responseDTO: EmptyResponseDTO = try await Provider().request(api)
        }
    )
}
