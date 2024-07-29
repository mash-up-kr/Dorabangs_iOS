//
//  Card.swift
//  Models
//
//  Created by 김영균 on 7/7/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation

public struct CardListModel {
    public let hasNext: Bool
    public let total: Int
    public let cards: [Card]

    public init(hasNext: Bool, total: Int, cards: [Card]) {
        self.hasNext = hasNext
        self.total = total
        self.cards = cards
    }
}

public struct Card: Hashable {
    public let id: String
    public let folderId: String
    public let urlString: String
    public let thumbnail: String?
    public let title: String
    public let description: String?
    public let category: String?
    public let createdAt: Date
    public var isFavorite: Bool?
    public let keywords: [Keyword]?
    public let aiStatus: AIStatus?

    public init(
        id: String,
        folderId: String,
        urlString: String,
        thumbnail: String? = nil,
        title: String,
        description: String? = nil,
        category: String? = nil,
        createdAt: Date,
        isFavorite: Bool? = nil,
        keywords: [Keyword]? = nil,
        thumbnailImageUrl _: String? = nil,
        aiStatus: AIStatus? = nil
    ) {
        self.id = id
        self.folderId = folderId
        self.urlString = urlString
        self.thumbnail = thumbnail
        self.title = title
        self.description = description
        self.category = category
        self.createdAt = createdAt
        self.isFavorite = isFavorite
        self.keywords = keywords
        self.aiStatus = aiStatus
    }
}
