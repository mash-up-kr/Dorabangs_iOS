//
//  RequestInterceptor.swift
//  Services
//
//  Created by 김영균 on 7/7/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Alamofire
import Foundation

final class RequestHeaderInterceptor: RequestInterceptor {
    private let keyChainClient: KeychainClient

    init(keyChainClient: KeychainClient = .liveValue) {
        self.keyChainClient = keyChainClient
    }

    func adapt(_ urlRequest: URLRequest, for _: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        if let accessToken = keyChainClient.accessToken {
            urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(urlRequest))
    }
}
