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
    case getPosts
    case postCard(folderId: String, urlString: String)
}

extension PostAPI {
    var path: String { "/posts" }

    var method: HTTPMethod {
        switch self {
        case .getPosts:
            .get
        case .postCard:
            .post
        }
    }

    var headers: HTTPHeaders? { nil }

    var queryString: Parameters? { nil }

    var httpBody: BodyParameters? {
        switch self {
        case .getPosts:
            .none

        case let .postCard(folderId, urlString):
            .dictionary(["folderId": folderId, "url": urlString])
        }
    }
}
