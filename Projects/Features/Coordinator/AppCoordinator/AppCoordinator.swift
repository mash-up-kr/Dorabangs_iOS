//
//  AppCoordinator.swift
//  AppCoordinator
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Splash
import TabCoordinator
import TCACoordinators

@Reducer(state: .equatable)
public enum AppScreen {
    case splash(Splash)
    case tabCoordinator(TabCoordinator)
}

@Reducer
public struct AppCoordinator {
    @ObservableState
    public struct State: Equatable {
        public static let initialState = State(
            routes: [.root(.tabCoordinator(.initialState), embedInNavigationView: true)]
        )
        var routes: [Route<AppScreen.State>]

        public init(routes: [Route<AppScreen.State>]) {
            self.routes = routes
        }
    }

    public enum Action {
        case router(IndexedRouterActionOf<AppScreen>)
        case saveURL(String)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case let .saveURL(url):
                .send(.router(.routeAction(id: 0, action: .tabCoordinator(.saveURL(url)))))
            default:
                .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
