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
    public var getPostsCount: @Sendable (_ isRead: Bool) async throws -> Int
    public var postPosts: (_ folderId: String, _ url: URL) async throws -> Void
    /// Post 북마크 여부
    public var isFavoritePost: @Sendable (_ postId: String, _ isFavorite: Bool) async throws -> Card
    /// Post 읽음 처리
    public var readPost: @Sendable (_ postId: String) async throws -> Card
    /// Post 삭제
    public var deletePost: @Sendable (_ postId: String) async throws -> Void
    /// URL 폴더 변경
    public var movePostFolder: @Sendable (_ postId: String, _ folderId: String) async throws -> Void
    /// 단일 피드 조회
    public var getPost: @Sendable (_ postId: String) async throws -> Card
}

public extension DependencyValues {
    var postAPIClient: PostAPIClient {
        get { self[PostAPIClient.self] }
        set { self[PostAPIClient.self] = newValue }
    }
}

extension PostAPIClient: DependencyKey {
    public static var liveValue: PostAPIClient = .init(
        getPosts: { page, limit, order, favorite in
            let api = PostAPI.getPosts(page: page ?? 1, limit: limit, order: order, favorite: favorite)
            let responseDTO: GetPostsResponseDTO = try await Provider().request(api)
            let cardList = responseDTO.list.map(\.toDomain)
            return cardList
        },
        getPostsCount: { isRead in
            let api = PostAPI.getPostsCount(isRead: isRead)
            let unreadCount: Int = try await Provider().request(api)
            return unreadCount
        },
        postPosts: { folderId, url in
            let api = PostAPI.postCard(folderId: folderId, urlString: url.absoluteString)
            let responseDTO: CardDTO = try await Provider().request(api)
        },
        isFavoritePost: { postId, isFavorite in
            let api = PostAPI.patchPost(postId: postId, isFavorite: isFavorite)
            let responseDTO: CardDTO = try await Provider().request(api)
            return responseDTO.toDomain
        },
        readPost: { postId in
            let DateFormatter = ISO8601DateFormatter()
            let dateString = DateFormatter.string(from: Date())
            let api = PostAPI.patchPost(postId: postId, read: dateString)
            let responseDTO: CardDTO = try await Provider().request(api)
            return responseDTO.toDomain
        },
        deletePost: { postId in
            let api = PostAPI.deletePost(postId: postId)
            let responseDTO: EmptyResponseDTO = try await Provider().request(api)
        },
        movePostFolder: { postId, folderId in
            let api = PostAPI.movePostFolder(postId: postId, folderId: folderId)
            let responseDTO: EmptyResponseDTO = try await Provider().request(api)
        },
        getPost: { postId in
            let api = PostAPI.getPost(postId: postId)
            let responseDTO: CardDTO = try await Provider().request(api)
            return responseDTO.toDomain
        }
    )
}
