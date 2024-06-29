//
//  File.swift
//  AppCoordinator
//
//  Created by 박소현 on 6/29/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Feed
import TCACoordinators

@Reducer(state: .equatable)
public enum FeedScreen {
    case feed(Feed)
}

@Reducer
public struct FeedCoordinator {
    @ObservableState
    public struct State: Equatable {
        public static let initialState = State(routes: [.root(.feed(.initialState), embedInNavigationView: true)])
        var routes: [Route<FeedScreen.State>]

        public init(routes: [Route<FeedScreen.State>]) {
            self.routes = routes
        }
    }
    
    public enum Action {
        case router(IndexedRouterActionOf<FeedScreen>)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            default:
                .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
    
    
}
