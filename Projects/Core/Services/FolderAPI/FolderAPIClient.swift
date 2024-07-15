//
//  FolderAPIClient.swift
//  Services
//
//  Created by 안상희 on 7/14/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Dependencies
import DependenciesMacros
import Foundation
import Models

@DependencyClient
public struct FolderAPIClient {
    public var getFolders: @Sendable () async throws -> [Folder]
    public var getFolderPosts: @Sendable (
        _ folderId: String,
        _ page: Int?,
        _ limit: Int?,
        _ unread: Bool?
    ) async throws -> [Card]
}

public extension DependencyValues {
    var folderAPIClient: FolderAPIClient {
        get { self[FolderAPIClient.self] }
        set { self[FolderAPIClient.self] = newValue }
    }
}

extension FolderAPIClient: DependencyKey {
    public static var liveValue: FolderAPIClient = .init(
        getFolders: {
            let api = FolderAPI.getFolders
            let responseDTO: GetFolderResponseDTO = try await Provider().request(api)
            let defaultFolders = responseDTO.defaultFolders.map(\.toDomain)
            let customFolders = responseDTO.customFolders.map(\.toDomain)
            let folderList = defaultFolders + customFolders
            return folderList
        },
        getFolderPosts: { folderId, page, limit, unread in
            let api = FolderAPI.getFolderPosts(folderId: folderId, page: page, limit: limit, unread: unread)
            let responseDTO: GetFolderPostsResponseDTO = try await Provider().request(api)
            let cardList = responseDTO.list.map(\.toDomain)
            return cardList
        }
    )
}
