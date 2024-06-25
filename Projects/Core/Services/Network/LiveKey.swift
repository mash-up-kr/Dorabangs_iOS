//
//  TestKey.swift
//  Services
//
//  Created by 박소현 on 6/25/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//
import Foundation
import Dependencies
import Foundation
import ComposableArchitecture
import Alamofire

extension DependencyValues {
    public var apiClient: ApiClient {
        get { self[ApiClient.self] }
        set { self[ApiClient.self] = newValue }
    }
}
extension ApiClient: DependencyKey {
    public static let liveValue = Self.live()
    
    public static func live(
        baseUrl: URL = URL(string: "http://localhost:9876")!
    ) -> Self {
        actor Session {
            var baseUrl: URL
            
            init(baseUrl: URL) {
                self.baseUrl = baseUrl
            }
            
            func apiRequest(route: ServerRoute.Api.Route) async throws -> (Data, URLResponse) {
                try await self.apiRequest(route: route)
            }
            
            func request(route: ServerRoute) async throws -> (Data, URLResponse) {
                try await self.request(route: route)
            }
            
            func setBaseUrl(_ url: URL) {
                self.baseUrl = url
            }
        }
        
        let session = Session(baseUrl: baseUrl)
        
        return Self(
            apiRequest: { try await session.apiRequest(route: $0 )},
            baseUrl: { session.baseUrl },
            request: { try await session.request(route: $0) },
            setBaseUrl: { await session.setBaseUrl($0) }
        )
    }
    
    
    
}
