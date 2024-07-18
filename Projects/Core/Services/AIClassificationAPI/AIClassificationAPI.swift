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
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getFolders, .getPosts: .get
        }
    }

    var headers: HTTPHeaders? { nil }

    var queryString: Parameters? {
        switch self {
        case .getFolders: .none
        case let .getPosts(_, page): ["page": page]
        }
    }

    var httpBody: BodyParameters? { nil }
}
