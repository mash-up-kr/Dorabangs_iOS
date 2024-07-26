//
//  AIClassificationCardDTO.swift
//  Models
//
//  Created by 김영균 on 7/18/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation
import Models

struct AIClassificationCardDTO: Decodable {
    let postId: String
    let folderId: String
    let url: String
    let title: String
    let description: String
    let createdAt: String
    let keywords: [String]
    let aiStatus: AISummaryStatusDTO?
    let thumbnailImgUrl: String?
    let readAt: String?
}

extension AIClassificationCardDTO {
    var toDomain: Card {
        Card(
            id: postId,
            folderId: folderId,
            urlString: url,
            thumbnail: thumbnailImgUrl,
            title: title,
            description: description,
            createdAt: convertISO8601StringToDate(createdAt) ?? .now,
            keywords: keywords.map { Keyword(id: UUID().uuidString, name: $0) },
            aiStatus: aiStatus?.toDomain ?? .inProgress
        )
    }

    func convertISO8601StringToDate(_ iso8601String: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let date = dateFormatter.date(from: iso8601String)
        return date
    }
}
