//
//  BaseResponse.swift
//  Services
//
//  Created by 김영균 on 7/7/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation

public struct BaseDataResponse<T: Decodable>: Decodable {
    public let success: Bool
    public let data: T?
}

public struct ErrorResponse: Decodable {
    public let success: Bool
    public let error: Error

    public struct Error: Decodable {
        public let code: String
        public let message: Message

        public struct Message: Decodable {
            public let message: String
            public let statusCode: Int
        }
    }
}

extension BaseDataResponse {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        data = try container.decode(T.self, forKey: .data)
    }

    private enum CodingKeys: String, CodingKey {
        case success
        case data
    }
}

extension ErrorResponse {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        success = try container.decode(Bool.self, forKey: .success)
        error = try container.decode(Error.self, forKey: .error)
    }

    private enum CodingKeys: String, CodingKey {
        case success
        case error
    }
}

extension ErrorResponse.Error {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(String.self, forKey: .code)
        message = try container.decode(Message.self, forKey: .message)
    }

    private enum CodingKeys: String, CodingKey {
        case code
        case message
    }
}

extension ErrorResponse.Error.Message {
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        message = try container.decode(String.self, forKey: .message)
        statusCode = try container.decode(Int.self, forKey: .statusCode)
    }

    private enum CodingKeys: String, CodingKey {
        case message
        case statusCode
    }
}
