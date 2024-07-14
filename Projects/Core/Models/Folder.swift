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
}
