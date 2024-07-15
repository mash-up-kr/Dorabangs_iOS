//
//  FolderAPI.swift
//  Services
//
//  Created by 안상희 on 7/14/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Alamofire
import Foundation

enum FolderAPI: APIRepresentable {
    case getFolders
    case postFolders(folders: [String])
    case getFolderPosts(folderId: String, page: Int?, limit: Int?, unread: Bool?)
}

extension FolderAPI {
    var path: String {
        switch self {
        case .getFolders, .postFolders:
            "/folders"
        case let .getFolderPosts(folderId, page, limit, unread):
            "/folders/\(folderId)/posts"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getFolders, .getFolderPosts:
            .get
        case .postFolders:
            .post
        }
    }

    var headers: HTTPHeaders? { nil }

    var queryString: Parameters? { nil }

    var httpBody: BodyParameters? {
        switch self {
        case .getFolders, .getFolderPosts:
            .none
        case let .postFolders(folders):
            .dictionary(["names": folders])
        }
    }
}
