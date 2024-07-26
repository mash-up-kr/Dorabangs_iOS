//
//  FolderClient.swift
//  Services
//
//  Created by 안상희 on 7/27/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Dependencies
import DependenciesMacros
import Foundation

// MARK: - Interface
@DependencyClient
public struct FolderClient: Sendable {
    public var setFolder: @Sendable (_ folderId: String, _ folderName: String) -> [String: String] = { _, _ in ["": ""] }
    public var setFolderList: @Sendable ([String: String]) -> Bool = { _ in false }
    public var getFolderName: @Sendable (_ folderId: String) -> String?
    public var removeFolder: @Sendable (_ folderId: String) -> Bool = { _ in false }
}

final class UserFolder {
    static let shared = UserFolder()

    var list = [String: String]()

    private init() {}
}

public extension DependencyValues {
    var folderClient: FolderClient {
        get { self[FolderClient.self] }
        set { self[FolderClient.self] = newValue }
    }
}

// MARK: - Live
extension FolderClient: DependencyKey {
    public static var liveValue: FolderClient {
        let userFolder = UserFolder.shared
        return FolderClient(
            setFolder: { folderId, folderName in
                userFolder.list[folderId] = folderName
                return userFolder.list
            },
            setFolderList: { folderList in
                for folder in folderList {
                    userFolder.list[folder.key] = folder.value
                }
                return !userFolder.list.isEmpty
            },
            getFolderName: { folderId in
                userFolder.list[folderId]
            },
            removeFolder: { folderId in
                userFolder.list.removeValue(forKey: folderId)
                return userFolder.list[folderId] == nil
            }
        )
    }
}
