//
//  GetPostsResponseDTO.swift
//  Services
//
//  Created by 안상희 on 7/16/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation

struct GetPostsResponseDTO: Decodable {
    let metadata: MetadataDTO
    let list: [CardDTO]
}
