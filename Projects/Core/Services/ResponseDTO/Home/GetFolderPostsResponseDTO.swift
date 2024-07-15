//
//  GetFolderPostsResponseDTO.swift
//  Services
//
//  Created by 안상희 on 7/15/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation

struct GetFolderPostsResponseDTO: Decodable {
    let list: [CardDTO]
    let hasNext: Bool
    let total: Int
}
