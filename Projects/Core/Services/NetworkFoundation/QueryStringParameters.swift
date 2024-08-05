//
//  QueryStringParameters.swift
//  Services
//
//  Created by 김영균 on 7/20/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Alamofire
import Foundation

public enum QueryStringParameters {
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

    public func encode(_ urlRequest: URLRequestConvertible) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()

        switch self {
        case let .dictionary(dict):
            let nilFilteredDictionary = filterNilValues(from: dict)
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: nilFilteredDictionary)

        case let .encodable(encodable):
            let nilFilteredDictionary = filterNilValues(from: encodable.asDictionary())
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: nilFilteredDictionary)
        }
        return urlRequest
    }

    // 딕셔너리에서 nil 값을 필터링하는 함수
    func filterNilValues(from dictionary: [String: Any?]?) -> [String: Any] {
        dictionary?.compactMapValues { value in
            if let boolValue = value as? Bool {
                return boolValue ? "true" : "false"
            }
            return value
        } ?? [:]
    }
}
