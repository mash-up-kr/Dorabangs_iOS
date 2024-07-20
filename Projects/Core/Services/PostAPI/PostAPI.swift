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
    /// URL 링크 저장
    case postCard(folderId: String, urlString: String)
    /// Post 상태 변경 (좋아요 / 읽음)
    case patchPost(postId: String, isFavorite: Bool? = nil, read: Bool? = nil)
    /// URL 삭제
    case deletePost(postId: String)
}

extension PostAPI {
    var path: String {
        switch self {
        case .getPosts, .postCard:
            "/posts"
        case let .patchPost(postId, _, _),
            let .deletePost(postId):
            "/posts/\(postId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getPosts:
            .get
        case .postCard:
            .post
        case .patchPost:
            .patch
        case .deletePost:
            .delete
        }
    }

    var headers: HTTPHeaders? { nil }

    var queryString: Parameters? { nil }

    var httpBody: BodyParameters? {
        switch self {
        case .getPosts, .deletePost(_):
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
        }
    }
}
