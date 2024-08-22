//
//  Folder.swift
//  Models
//
//  Created by 김영균 on 7/7/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation
import LocalizationKit

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
    public var createdAt: String?
    // createdAt을 Date로 변환하는 computed property
    public var creationDate: Date? {
        guard let createdAt else { return nil }
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: createdAt)
    }

    public init(
        id: String,
        name: String,
        type: FolderType,
        postCount: Int,
        createdAt: String? = nil
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.postCount = postCount
        self.createdAt = createdAt
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

public extension FoldersModel {
    var toFolderList: [Folder] {
        defaultFolders + customFolders
    }
}

public extension Folder {
    var toLocalized: Folder {
        switch type {
        case .custom: self
        case .default: Folder(id: id, name: localizedName, type: type, postCount: postCount, createdAt: createdAt)
        case .all: Folder(id: id, name: localizedName, type: type, postCount: postCount, createdAt: createdAt)
        case .favorite: Folder(id: id, name: localizedName, type: type, postCount: postCount, createdAt: createdAt)
        }
    }

    var localizedName: String {
        switch type {
        case .custom: name
        case .default: LocalizationKitStrings.Common.readLaterLink
        case .all: LocalizationKitStrings.Common.all
        case .favorite: LocalizationKitStrings.Common.bookmarks
        }
    }
}
