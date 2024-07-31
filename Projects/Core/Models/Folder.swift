//
//  Folder.swift
//  Models
//
//  Created by 김영균 on 7/7/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation

public struct FoldersModel: Hashable {
    public var defaultFolders: [Folder]
    public var customFolders: [Folder]

    public init(defaultFolders: [Folder],
                customFolders: [Folder])
    {
        self.defaultFolders = defaultFolders
        self.customFolders = customFolders
    }
}

public struct Folder: Hashable {
    public var id: String
    public var name: String
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

public extension Folder {
    enum ID {
        public static let all = "all"
        public static let favorite = "favorite"
    }
}
