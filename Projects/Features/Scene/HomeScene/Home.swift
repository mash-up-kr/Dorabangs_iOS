//
//  Home.swift
//  Home
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//
import Foundation
import ComposableArchitecture
import Services

@Reducer
public struct Home {
    @ObservableState
    public struct State: Equatable {
        public static let initialState = State()
        public init() {}
    }
    
    public enum Action {
        case onAppear
        case buttonTap
        case fetchTestDataResponse(TaskResult<[String:String]>)
    }
    
    public init() {}
    
    @Dependency(\.apiClient) var apiClient
    
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .none
            case .buttonTap:
//                return .run { send in
//                    await send(.fetchTestDataResponse(
//                        TaskResult { try await
////                            apiClient.fetchProducts()
//                        }
//                    ))
//                }
                return .none
            case .fetchTestDataResponse(.success(let data)):
                print("==== success data : \(data)")
                return .none
            case .fetchTestDataResponse(.failure(let error)):
                print("==== fail error : \(error)")
                return .none
            }
        }
    }    
}
