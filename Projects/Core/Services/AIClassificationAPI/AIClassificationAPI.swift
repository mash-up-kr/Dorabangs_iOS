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
    case deletePost(postId: String)
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
        case let .deletePost(postId):
            "/classification/posts/\(postId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getFolders, .getPosts: .get
        case .deletePost: .delete
        }
    }

    var headers: HTTPHeaders? { nil }

    var queryString: Parameters? {
        switch self {
        case .getFolders: .none
        case let .getPosts(_, page): ["page": page]
        case .deletePost: .none
        }
    }

    var httpBody: BodyParameters? { nil }
}
