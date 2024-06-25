//
//  Helpers.swift
//  Services
//
//  Created by 박소현 on 6/25/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

#if DEBUG
import Foundation

public func OK<A: Encodable>(
    _ value: A, encoder: JSONEncoder = .init()
) async throws -> (Data, URLResponse) {
    (
        try encoder.encode(value),
        HTTPURLResponse(
            url: URL(string: "/")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    )
}

public func OK(_ jsonObject: Any) async throws -> (Data, URLResponse) {
    (
        try JSONSerialization.data(withJSONObject: jsonObject, options: []),
        HTTPURLResponse(
            url: URL(string: "/")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    )
}
#endif

