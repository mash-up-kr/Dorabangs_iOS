//
//  AIClassificationAPI.swift
//  Services
//
//  Created by 김영균 on 7/18/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Alamofire
import Foundation

enum AIClassificationAPI: APIRepresentable {
    case getFolders
    case getPosts(folderId: String?, page: Int)
    case getAIClassificationCount
    case deletePost(postId: String)
    case patchAllPost(suggestionFolderId: String)
    case patchPost(suggestionFolderId: String, postId: String)
}

extension AIClassificationAPI {
    var path: String {
        switch self {
        case .getFolders:
            "/classification/folders"
        case let .getPosts(folderId, _):
            if let folderId {
                "/classification/posts/\(folderId)"
            } else {
                "/classification/posts"
            }
        case .getAIClassificationCount:
            "/classification/count"
        case let .deletePost(postId):
            "/classification/posts/\(postId)"
        case .patchAllPost:
            "/classification/posts"
        case let .patchPost(_, postId):
            "/classification/posts/\(postId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getFolders, .getPosts, .getAIClassificationCount: .get
        case .deletePost: .delete
        case .patchAllPost, .patchPost: .patch
        }
    }

    var headers: HTTPHeaders? { nil }

    var queryString: QueryStringParameters? {
        switch self {
        case .getFolders, .getAIClassificationCount: .none
        case let .getPosts(_, page): .dictionary(["page": page])
        case .deletePost: .none
        case let .patchAllPost(suggestionFolderId): .dictionary(["suggestionFolderId": suggestionFolderId])
        case .patchPost: .none
        }
    }

    var httpBody: BodyParameters? {
        switch self {
        case .getFolders: .none
        case .getPosts: .none
        case .getAIClassificationCount: .none
        case .deletePost: .none
        case .patchAllPost: .none
        case let .patchPost(suggestionFolderId, _): .dictionary(["suggestionFolderId": suggestionFolderId])
        }
    }
}
