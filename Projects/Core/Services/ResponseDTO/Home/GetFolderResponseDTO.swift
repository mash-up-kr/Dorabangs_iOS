//
//  GetFolderResponseDTO.swift
//  Services
//
//  Created by 안상희 on 7/14/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation

struct GetFolderResponseDTO: Decodable {
    let defaultFolders: [FolderDTO]
    let customFolders: [FolderDTO]
}

struct FolderList: Decodable {
    let defaultFolders: [FolderDTO]
    let customFolders: [FolderDTO]
}
