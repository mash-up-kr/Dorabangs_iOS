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
    let id: String
    let userId: String?
    let folderId: String
    let url: String
    let title: String
    let description: String?
    let isFavorite: Bool?
    let createdAt: String?
    let readAt: String?
    let keywords: [KeywordDTO]?
    let thumbnailImagUrl: String?
    let aiStatus: AISummaryStatusDTO
}

extension CardDTO {
    var toDomain: Card {
        Card(
            id: id,
            folderId: folderId,
            urlString: url,
            thumbnail: nil,
            title: title,
            description: description,
            category: "",
            createdAt: convertISO8601StringToDate(createdAt ?? "") ?? .now,
            keywords: keywords.map { $0.map(\.toDomain) }
        )
    }

    private func convertISO8601StringToDate(_ iso8601String: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return dateFormatter.date(from: iso8601String)
    }
}
