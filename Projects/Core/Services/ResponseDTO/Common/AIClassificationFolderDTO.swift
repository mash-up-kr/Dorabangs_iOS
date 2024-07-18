//
//  AIClassificationFolderDTO.swift
//  Services
//
//  Created by 김영균 on 7/18/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation
import Models

struct AIClassificationFolderDTO: Decodable {
    let folderName: String
    let postCount: Int
    let folderId: String
}

extension AIClassificationFolderDTO {
    var toDomain: Folder {
        Folder(
            id: folderId,
            name: folderName,
            type: .custom,
            postCount: postCount
        )
    }
}
