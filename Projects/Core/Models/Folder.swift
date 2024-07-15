//
//  Folder.swift
//  Models
//
//  Created by 김영균 on 7/7/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation

public struct Folder: Hashable {
    public let id: String
    public let name: String
    public let type: FolderType
    public var postCount: Int

    public init(
        id: String,
        name: String,
        type: FolderType,
        postCount: Int
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.postCount = postCount
    }
}

public enum FolderType: Equatable {
    case custom
    case `default`
    case all
    case favorite

    public init?(type: String) {
        switch type.lowercased() {
        case "custom":
            self = .custom
        case "default":
            self = .default
        case "all":
            self = .all
        case "favorite":
            self = .favorite
        default:
            return nil
        }
    }

    public var toString: String {
        switch self {
        case .custom:
            "custom"
        case .default:
            "default"
        case .all:
            "all"
        case .favorite:
            "favorite"
        }
    }
}
