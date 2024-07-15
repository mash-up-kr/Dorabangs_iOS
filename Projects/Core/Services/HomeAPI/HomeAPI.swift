//
//  HomeAPI.swift
//  Services
//
//  Created by 안상희 on 7/14/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Alamofire
import Foundation

enum HomeAPI: APIRepresentable {
    case getFolders
    case getFolderPosts(folderId: String, page: Int?, limit: Int?, unread: Bool?)
}

extension HomeAPI {
    var path: String {
        switch self {
        case .getFolders:
            "/folders"
        case let .getFolderPosts(folderId, page, limit, unread):
            "/folders/\(folderId)/posts"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getFolders:
            .get

        case .getFolderPosts:
            .get
        }
    }

    var headers: HTTPHeaders? { nil }

    var queryString: Parameters? { nil }

    var httpBody: BodyParameters? {
        switch self {
        case .getFolders:
            .none

        case .getFolderPosts:
            .none
        }
    }
}
