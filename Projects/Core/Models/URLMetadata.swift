//
//  URLMetadata.swift
//  Services
//
//  Created by 김영균 on 7/2/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation

public struct URLMetadata: Equatable {
    // URL
    public var url: URL
    // URL 썸네일 이미지
    public var thumbnail: Data?
    // URL 제목
    public var title: String?

    public init(url: URL, thumbnail: Data? = nil, title: String? = nil) {
        self.url = url
        self.thumbnail = thumbnail
        self.title = title
    }
}
