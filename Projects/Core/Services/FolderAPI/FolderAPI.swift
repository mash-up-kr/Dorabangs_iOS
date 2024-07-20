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
    /// 단일 폴더 조회
    case getFolder(folderId: String)
    /// 폴더 리스트 조회
    case getFolders
    case postFolders(folders: [String])
    case getFolderPosts(folderId: String, page: Int?, limit: Int?, unread: Bool?)
    case deleteFolder(folderId: String)
    case patchFolder(folderId: String, newName: String)
}

extension FolderAPI {
    var path: String {
        switch self {
        case let .getFolder(folderId):
            "/folders/\(folderId)"
        case .getFolders, .postFolders:
            "/folders"
        case let .getFolderPosts(folderId, page, limit, unread):
            "/folders/\(folderId)/posts"
        case let .deleteFolder(folderId), let .patchFolder(folderId, _):
            "/folders/\(folderId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getFolder, .getFolders, .getFolderPosts:
            .get
        case .postFolders:
            .post
        case .deleteFolder:
            .delete
        case .patchFolder:
            .patch
        }
    }

    var headers: HTTPHeaders? { nil }

    var queryString: QueryStringParameters? { nil }

    var httpBody: BodyParameters? {
        switch self {
        case .getFolder, .getFolders, .getFolderPosts, .deleteFolder:
            .none
        case let .postFolders(folders):
            .dictionary(["names": folders])
        case let .patchFolder(_, newName):
            .dictionary(["name": newName])
        }
    }
}
