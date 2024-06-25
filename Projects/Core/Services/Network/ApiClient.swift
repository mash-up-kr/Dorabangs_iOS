//
//  Client.swift
//  Services
//
//  Created by 박소현 on 6/24/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DependenciesMacros
import Foundation
import Alamofire
import ComposableArchitecture

@DependencyClient
public struct ApiClient: Sendable {
    public var apiRequest: @Sendable (ServerRoute.Api.Route) async throws -> (Data, URLResponse)
    public var baseUrl: @Sendable () -> URL = { URL(string: "/")! }
    public var request: @Sendable (ServerRoute) async throws -> (Data, URLResponse)
    public var setBaseUrl: @Sendable (URL) async -> Void
    
    public func apiRequest(
        route: ServerRoute.Api.Route,
        file: StaticString = #file,
        line: UInt = #line
    ) async throws -> (Data, URLResponse) {
        do {
            let (data, response) = try await self.apiRequest(route)
#if DEBUG
            print(
                    """
                    API: route: \(route), \
                    status: \((response as? HTTPURLResponse)?.statusCode ?? 0), \
                    receive data: \(String(decoding: data, as: UTF8.self))
                    """
            )
#endif
            return (data, response)
        } catch {
            throw ApiError(error: error, file: file, line: line)
        }
    }
    
    public func apiRequest<A: Decodable>(
        route: ServerRoute.Api.Route,
        as: A.Type,
        file: StaticString = #file,
        line: UInt = #line
    ) async throws -> A {
        let (data, _) = try await self.apiRequest(route: route, file: file, line: line)
        do {
            return try apiDecode(A.self, from: data)
        } catch {
            throw ApiError(error: error, file: file, line: line)
        }
    }
    
    public func request(
        route: ServerRoute,
        file: StaticString = #file,
        line: UInt = #line
    ) async throws -> (Data, URLResponse) {
        do {
            let (data, response) = try await self.request(route)
#if DEBUG
            print(
        """
        API: route: \(route), \
        status: \((response as? HTTPURLResponse)?.statusCode ?? 0), \
        receive data: \(String(decoding: data, as: UTF8.self))
        """
            )
#endif
            return (data, response)
        } catch {
            throw ApiError(error: error, file: file, line: line)
        }
    }
    
    public func request<A: Decodable>(
        route: ServerRoute,
        as: A.Type,
        file: StaticString = #file,
        line: UInt = #line
    ) async throws -> A {
        let (data, _) = try await self.request(route: route, file: file, line: line)
        do {
            return try apiDecode(A.self, from: data)
        } catch {
            throw ApiError(error: error, file: file, line: line)
        }
    }
}

