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
    public static let liveValue = Self(
//        apiRequest: { _ in
//
//        }, baseUrl: {
//            
//        }, request: {_ in 
//            
//        }, setBaseUrl: {_ in 
//            
//        }
    )
}
