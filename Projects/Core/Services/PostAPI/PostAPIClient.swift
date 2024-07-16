//
//  PostAPIClient.swift
//  Services
//
//  Created by 안상희 on 7/16/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct PostAPIClient {
    public var postPosts: (_ folderId: String, _ url: URL) async throws -> Void
}

public extension DependencyValues {
    var postAPIClient: PostAPIClient {
        get { self[PostAPIClient.self] }
        set { self[PostAPIClient.self] = newValue }
    }
}

extension PostAPIClient: DependencyKey {
    public static var liveValue: PostAPIClient = Self(
        postPosts: { folderId, url in
            let api = CardAPI.postCard(folderId: folderId, urlString: url.absoluteString)
            let responseDTO: EmptyResponseDTO = try await Provider().request(api)
        }
    )
}
