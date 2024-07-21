//
//  AISummaryStatusDTO.swift
//  Services
//
//  Created by 김영균 on 7/21/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation

enum AISummaryStatusDTO: String, Decodable {
    case success
    case inProgress
    case failure

    enum CodingKeys: String, CodingKey {
        case success
        case inProgress = "in_progress"
        case failure = "fail"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let value = try container.decode(String.self)
        switch value {
        case CodingKeys.success.rawValue:
            self = .success
        case CodingKeys.inProgress.rawValue:
            self = .inProgress
        case CodingKeys.failure.rawValue:
            self = .failure
        default:
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid status")
        }
    }
}
