//
//  BodyParameters.swift
//  Services
//
//  Created by 김영균 on 7/6/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Alamofire
import Foundation

public enum BodyParameters {
    case dictionary(Parameters)
    case encodable(Encodable)

    public func asDictionary() -> [String: Any]? {
        switch self {
        case let .dictionary(dict):
            dict

        case let .encodable(encodable):
            encodable.asDictionary()
        }
    }

    public func encode(_ urlRequest: any URLRequestConvertible) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()

        switch self {
        case let .dictionary(dict):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: dict)

        case let .encodable(encodable):
            urlRequest = try JSONEncoding.default.encode(urlRequest, with: encodable.asDictionary())
        }
        return urlRequest
    }
}

extension Encodable {
    func asDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }
}
