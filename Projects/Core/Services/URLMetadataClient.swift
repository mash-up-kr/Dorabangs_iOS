//
//  URLMetadataClient.swift
//  Services
//
//  Created by 김영균 on 7/2/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Dependencies
import DependenciesMacros
import Foundation
import LinkPresentation
import Models
import UniformTypeIdentifiers

@DependencyClient
public struct URLMetadataClient: Sendable {
    public var fetchMetadata: @Sendable (URL) async throws -> URLMetadata
    public var fetchOriginalURL: @Sendable (URL) async throws -> URL
}

extension URLMetadataClient: DependencyKey {
    public static var liveValue: URLMetadataClient = Self(
        fetchMetadata: { @MainActor url in
            let metadataProvider = LPMetadataProvider()
            let metadata = try await metadataProvider.startFetchingMetadata(for: url)
            let thumbnailData = try await metadata.imageProvider?.loadItem(forTypeIdentifier: UTType.image.identifier) as? Data
            return URLMetadata(
                url: metadata.url ?? url,
                thumbnail: thumbnailData,
                title: metadata.title
            )
        },
        fetchOriginalURL: { @MainActor url in
            let metadataProvider = LPMetadataProvider()
            let metadata = try await metadataProvider.startFetchingMetadata(for: url)
            return metadata.url ?? url
        }
    )
}

public extension DependencyValues {
    var urlMetadataClient: URLMetadataClient {
        get { self[URLMetadataClient.self] }
        set { self[URLMetadataClient.self] = newValue }
    }
}

// 출처: https://forums.swift.org/t/how-to-use-non-sendable-type-in-async-reducer-code/62069/6
extension NSItemProvider: @unchecked Sendable {}
