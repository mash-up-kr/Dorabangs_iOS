//
//  PostAPI.swift
//  Services
//
//  Created by 안상희 on 7/16/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Alamofire
import Foundation

enum PostAPI: APIRepresentable {
    /// 전체 피드 조회
    case getPosts
    /// 피드 갯수 반환
    case getPostsCount(isRead: Bool)
    /// URL 링크 저장
    case postCard(folderId: String, urlString: String)
    /// Post 상태 변경 (좋아요 / 읽음)
    case patchPost(postId: String, isFavorite: Bool? = nil, read: String? = nil)
    /// URL 삭제
    case deletePost(postId: String)
    /// URL 폴더 변경
    case movePostFolder(postId: String, folderId: String)
}

extension PostAPI {
    var path: String {
        switch self {
        case .getPosts, .postCard:
            "/posts"
        case .getPostsCount:
            "/posts/count"
        case let .patchPost(postId, _, _),
             let .deletePost(postId):
            "/posts/\(postId)"
        case let .movePostFolder(postId, _):
            "/posts/\(postId)/move"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getPosts, .getPostsCount:
            .get
        case .postCard:
            .post
        case .patchPost, .movePostFolder:
            .patch
        case .deletePost:
            .delete
        }
    }

    var headers: HTTPHeaders? { nil }

    var queryString: QueryStringParameters? {
        switch self {
        case let .getPostsCount(isRead):
            .dictionary(["isRead": isRead])
        default: nil
        }
    }

    var httpBody: BodyParameters? {
        switch self {
        case .getPosts, .getPostsCount, .deletePost:
            .none
        case let .postCard(folderId, urlString):
            .dictionary(["folderId": folderId, "url": urlString])
        case let .patchPost(_, isFavorite, read):
            if let isFavorite {
                .dictionary(["isFavorite": isFavorite])
            } else if let read {
                .dictionary(["readAt": read])
            } else {
                .none
            }
        case let .movePostFolder(_, folderId):
            .dictionary(["folderId": folderId])
        }
    }
}
