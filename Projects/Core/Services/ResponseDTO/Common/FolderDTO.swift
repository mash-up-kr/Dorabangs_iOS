//
//  FolderDTO.swift
//  Services
//
//  Created by 안상희 on 7/14/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation
import Models

struct FolderDTO: Decodable {
    let id: String?
    let name: String
    let type: String
    let postCount: Int?
    let createdAt: String?

    public init(
        id: String?,
        name: String,
        type: String,
        postCount: Int? = nil,
        createdAt: String? = nil
    ) {
        self.id = id
        self.name = name
        self.type = type
        self.postCount = postCount
        self.createdAt = createdAt
    }
}

extension FolderDTO {
    var toDomain: Folder {
        Folder(
            id: id ?? "",
            name: name,
            type: FolderType(type: type) ?? .default,
            postCount: postCount ?? 0,
            createdAt: createdAt
        )
    }
}
