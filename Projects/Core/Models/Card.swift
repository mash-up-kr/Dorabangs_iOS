//
//  Card.swift
//  Models
//
//  Created by 김영균 on 7/7/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation

public struct Card: Hashable {
    public let id: String
    public let folderId: String
    public let urlString: String
    public let thumbnail: String?
    public let title: String
    public let description: String?
    public let category: String
    public let createdAt: Date
    public let keywords: [Keyword]

    public init(
        id: String,
        folderId: String,
        urlString: String,
        thumbnail: String?,
        title: String,
        description: String?,
        category: String,
        createdAt: Date,
        keywords: [Keyword]
    ) {
        self.id = id
        self.folderId = folderId
        self.urlString = urlString
        self.thumbnail = thumbnail
        self.title = title
        self.description = description
        self.category = category
        self.createdAt = createdAt
        self.keywords = keywords
    }
}
