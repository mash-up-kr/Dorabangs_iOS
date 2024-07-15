//
//  HomeAPIClient.swift
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
public struct HomeAPIClient {
    public var getFolders: @Sendable () async throws -> [Folder]
    public var getFolderPosts: @Sendable (
        _ folderId: String,
        _ page: Int?,
        _ limit: Int?,
        _ unread: Bool?
    ) async throws -> [Card]
}

public extension DependencyValues {
    var homeAPIClient: HomeAPIClient {
        get { self[HomeAPIClient.self] }
        set { self[HomeAPIClient.self] = newValue }
    }
}

extension HomeAPIClient: DependencyKey {
    public static var liveValue: HomeAPIClient = .init(
        getFolders: {
            let api = HomeAPI.getFolders
            let responseDTO: GetFolderResponseDTO = try await Provider().request(api)
            let defaultFolders = responseDTO.defaultFolders.map(\.toDomain)
            let customFolders = responseDTO.customFolders.map(\.toDomain)
            let folderList = defaultFolders + customFolders
            return folderList
        },
        getFolderPosts: { folderId, page, limit, unread in
            let api = HomeAPI.getFolderPosts(folderId: folderId, page: page, limit: limit, unread: unread)
            let responseDTO: GetFolderPostsResponseDTO = try await Provider().request(api)
            let cardList = responseDTO.list.map(\.toDomain)
            return cardList
        }
    )
}
