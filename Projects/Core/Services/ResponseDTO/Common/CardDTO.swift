//
//  CardDTO.swift
//  Services
//
//  Created by 안상희 on 7/15/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation
import Models

struct CardDTO: Decodable {
    let userId: String
    let folderId: String
    let url: String
    let title: String
    let description: String?
    let isFavorite: Bool
    let createdAt: String
    let keywords: [KeywordDTO]?
}

extension CardDTO {
    var toDomain: Card {
        Card(
            id: userId,
            folderId: folderId,
            urlString: url,
            thumbnail: nil,
            title: title,
            description: description,
            category: "",
            createdAt: .now,
            keywords: keywords.map { $0.map { $0.toDomain } }
        )
    }
}
