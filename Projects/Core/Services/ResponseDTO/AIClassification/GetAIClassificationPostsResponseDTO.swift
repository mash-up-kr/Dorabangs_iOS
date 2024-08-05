//
//  GetAIClassificationPostsResponseDTO.swift
//  Models
//
//  Created by 김영균 on 7/18/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation

struct GetAIClassificationPostsResponseDTO: Decodable {
    let metadata: MetadataDTO
    let list: [AIClassificationCardDTO]
}
