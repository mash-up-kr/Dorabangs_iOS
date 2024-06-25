//
//  ApiDecode.swift
//  Services
//
//  Created by 박소현 on 6/24/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Combine
import Foundation

public func apiDecode<A: Decodable>(_ type: A.Type, from data: Data) throws -> A {
    do {
        return try JSONDecoder().decode(A.self, from: data)
    } catch let decodingError {
        let apiError: Error
        do {
            apiError = try JSONDecoder().decode(ApiError.self, from: data)
        } catch {
            throw decodingError
        }
        throw apiError
    }
}
