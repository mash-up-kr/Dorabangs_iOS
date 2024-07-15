//
//  KeywordDTO.swift
//  Services
//
//  Created by 안상희 on 7/15/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation
import Models

struct KeywordDTO: Decodable {
    let id: String
    let name: String
}

extension KeywordDTO {
    var toDomain: Keyword {
        Keyword(
            id: id,
            name: name
        )
    }
}
