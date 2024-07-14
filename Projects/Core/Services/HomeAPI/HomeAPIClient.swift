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
            let defaultFolders = responseDTO.defaultFolders.map { $0.toDomain }
            let customFolders = responseDTO.customFolders.map { $0.toDomain }
            let folderList = defaultFolders + customFolders
            return folderList
        }
    )
}
