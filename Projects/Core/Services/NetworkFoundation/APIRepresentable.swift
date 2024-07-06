//
//  APIRepresentable.swift
//  Services
//
//  Created by 김영균 on 7/6/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Alamofire
import Foundation

public protocol APIRepresentable: URLRequestConvertible {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: HTTPHeaders? { get }
    var queryString: Parameters? { get }
    var httpBody: BodyParameters? { get }
}

public extension APIRepresentable {
    func asURLRequest() throws -> URLRequest {
        let url = try URL(target: self)
        var urlRequest = try URLRequest(url: url, method: method)
        urlRequest = try urlRequest.addHeaders(headers)
        if let queryString {
            urlRequest = try URLEncoding.queryString.encode(urlRequest, with: queryString)
        }
        if let httpBody {
            urlRequest = try httpBody.encode(urlRequest)
        }
        return urlRequest
    }
}

extension URLRequestConvertible {
    func addHeaders(_ headers: HTTPHeaders?) throws -> URLRequest {
        var urlRequest = try asURLRequest()
        guard let headers else { return urlRequest }
        urlRequest.headers = headers
        return urlRequest
    }
}
