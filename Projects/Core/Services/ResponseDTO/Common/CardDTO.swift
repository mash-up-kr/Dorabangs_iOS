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
    let userId: String? // TODO: 사용하는 곳 없으면 제거필요
    let folderId: String
    let url: String
    let title: String
    let description: String?
    let isFavorite: Bool?
    let createdAt: String?
    let readAt: String?
    let keywords: [KeywordDTO]?
    let thumbnailImgUrl: String?
    let aiStatus: AISummaryStatusDTO?
}

extension CardDTO {
    var toDomain: Card {
        Card(
            id: id,
            folderId: folderId,
            urlString: url,
            thumbnail: thumbnailImgUrl,
            title: title,
            description: description,
            category: "",
            createdAt: convertISO8601StringToDate(createdAt ?? "") ?? .now,
            readAt: convertISO8601StringToDate(readAt ?? ""),
            isFavorite: isFavorite,
            keywords: keywords.map { $0.map(\.toDomain) },
            aiStatus: aiStatus?.toDomain
        )
    }

    private func convertISO8601StringToDate(_ iso8601String: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return dateFormatter.date(from: iso8601String)
    }
}
