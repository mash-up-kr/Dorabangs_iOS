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
    public var getFolder: @Sendable (String) async throws -> Folder
    public var getFolders: @Sendable () async throws -> FoldersModel
    public var postFolders: @Sendable ([String]) async throws -> [Folder]
    public var getFolderPosts: @Sendable (
        _ folderId: String,
        _ page: Int?,
        _ limit: Int?,
        _ order: String?,
        _ unread: Bool?
    ) async throws -> CardListModel
    public var deleteFolder: @Sendable (String) async throws -> Void
    public var patchFolder: @Sendable (String, String) async throws -> Folder
}

public extension DependencyValues {
    var folderAPIClient: FolderAPIClient {
        get { self[FolderAPIClient.self] }
        set { self[FolderAPIClient.self] = newValue }
    }
}

extension FolderAPIClient: DependencyKey {
    public static var liveValue: FolderAPIClient = .init(
        getFolder: { folderId in
            let api = FolderAPI.getFolder(folderId: folderId)
            let responseDTO: FolderDTO = try await Provider().request(api)
            let folder = responseDTO.toDomain
            return folder
        },
        getFolders: {
            let api = FolderAPI.getFolders
            let responseDTO: GetFolderResponseDTO = try await Provider().request(api)
            let defaultFolders = responseDTO.defaultFolders.map(\.toDomain)
            let customFolders = responseDTO.customFolders.map(\.toDomain)
            let folderModel = FoldersModel(defaultFolders: defaultFolders, customFolders: customFolders)
            return folderModel
        },
        postFolders: { folders in
            let api = FolderAPI.postFolders(folders: folders)
            let responseDTO: PostFolderResponseDTO = try await Provider().request(api)
            return responseDTO.list.map(\.toDomain)
        },
        getFolderPosts: { folderId, page, limit, order, unread in
            let api = FolderAPI.getFolderPosts(folderId: folderId, page: page, limit: limit, order: order, unread: unread)
            let responseDTO: GetFolderPostsResponseDTO = try await Provider().request(api)
            let cardList = responseDTO.list.map(\.toDomain)
            return CardListModel(hasNext: responseDTO.hasNext, total: responseDTO.total, cards: cardList)
        },
        deleteFolder: { folderId in
            let api = FolderAPI.deleteFolder(folderId: folderId)
            let responseDTO: EmptyResponseDTO = try await Provider().request(api)
        },
        patchFolder: { folderId, newName in
            let api = FolderAPI.patchFolder(folderId: folderId, newName: newName)
            let responseDTO: FolderDTO = try await Provider().request(api)
            let patchedFolder = responseDTO.toDomain
            return patchedFolder
        }
    )
}
