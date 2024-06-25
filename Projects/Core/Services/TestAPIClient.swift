//
//  APIClient.swift
//  Services
//
//  Created by 박소현 on 6/24/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation
import ComposableArchitecture

// 지울거에요
@DependencyClient
public struct TestAPIClient {
    // get
    public var fetchProducts: @Sendable () async throws -> [String:String]
    // post
    public var sendOrder:  @Sendable ([String]) async throws -> String
    
    struct Failure: Error, Equatable {}
}
extension TestAPIClient: DependencyKey {
    public static let liveValue = Self(
        fetchProducts: {
            let (data, _) = try await URLSession.shared
                .data(from: URL(string: "https://chickenfacts.io/api/v1/facts/31.json")!)
            let products = try JSONDecoder().decode([String:String].self, from: data)
            return products
        },
        sendOrder: { cartItems in
            let payload = try JSONEncoder().encode(cartItems)
            var urlRequest = URLRequest(url: URL(string: "https://fakestoreapi.com/carts")!)
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpMethod = "POST"
            
            let (data, response) = try await URLSession.shared.upload(for: urlRequest, from: payload)
            
            guard let httpResponse = (response as? HTTPURLResponse) else {
                throw Failure()
            }
            
            return "Status: \(httpResponse.statusCode)"
        }
    )
}
//extension DependencyValues {
//    public var apiClient: TestAPIClient {
//            get { self[TestAPIClient.self] }
//            set { self[TestAPIClient.self] = newValue }
//        }
//}
