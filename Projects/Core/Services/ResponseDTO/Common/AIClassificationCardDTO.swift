//
//  AIClassificationCardDTO.swift
//  Models
//
//  Created by 김영균 on 7/18/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation

struct AIClassificationCardDTO: Decodable {
    let postId: String
    let folderId: String?
    let url: String
    let title: String
    let description: String
    let createdAt: String
    let keywords: [String]
}

extension AIClassificationCardDTO {
    func convertISO8601StringToDate(_ iso8601String: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from: iso8601String)
    }
}
