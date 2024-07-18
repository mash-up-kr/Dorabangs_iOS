//
//  PostAPIClient.swift
//  Services
//
//  Created by 안상희 on 7/16/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Dependencies
import DependenciesMacros
import Foundation
import Models

@DependencyClient
public struct PostAPIClient {
    public var getPosts: @Sendable (
        _ page: Int?,
        _ limit: Int?,
        _ order: String?,
        _ favorite: Bool?
    ) async throws -> [Card]
    public var postPosts: (_ folderId: String, _ url: URL) async throws -> Void
}

public extension DependencyValues {
    var postAPIClient: PostAPIClient {
        get { self[PostAPIClient.self] }
        set { self[PostAPIClient.self] = newValue }
    }
}

extension PostAPIClient: DependencyKey {
    public static var liveValue: PostAPIClient = .init(
        getPosts: { _, _, _, _ in
            let api = PostAPI.getPosts
            let responseDTO: GetPostsResponseDTO = try await Provider().request(api)
            let cardList = responseDTO.list.map(\.toDomain)
            return cardList
        },
        postPosts: { folderId, url in
            let api = PostAPI.postCard(folderId: folderId, urlString: url.absoluteString)
            let responseDTO: EmptyResponseDTO = try await Provider().request(api)
        }
    )
}
