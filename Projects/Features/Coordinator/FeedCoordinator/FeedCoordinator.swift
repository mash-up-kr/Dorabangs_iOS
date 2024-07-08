//
//  FeedCoordinator.swift
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
        var routes: [Route<FeedScreen.State>]

        public init(routes: [Route<FeedScreen.State>]) {
            self.routes = routes
        }

        public init(title: String) {
            routes = [.root(.feed(.init(title: title)), embedInNavigationView: true)]
        }
    }

    public enum Action {
        case router(IndexedRouterActionOf<FeedScreen>)
        case routeToPreviousScreen
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .router(.routeAction(id: _, action: .feed(.routeToPreviousScreen))):
                .send(.routeToPreviousScreen)
            default:
                .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
