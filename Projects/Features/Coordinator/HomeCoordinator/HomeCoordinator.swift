//
//  HomeCoordinator.swift
//  HomeCoordinator
//
//  Created by 김영균 on 6/14/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Home
import SaveURLCoordinator
import TCACoordinators

@Reducer(state: .equatable)
public enum HomeScreen {
    case home(Home)
    case saveURLCoordinator(SaveURLCoordinator)
}

@Reducer
public struct HomeCoordinator {
    @ObservableState
    public struct State: Equatable {
        public static let initialState = State(routes: [.root(.home(.initialState), embedInNavigationView: false)])
        var routes: [Route<HomeScreen.State>]

        public init(routes: [Route<HomeScreen.State>]) {
            self.routes = routes
        }
    }

    public enum Action {
        case router(IndexedRouterActionOf<HomeScreen>)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .router(.routeAction(id: _, action: .home(.addLinkButtonTapped))):
                state.routes.push(.saveURLCoordinator(.initialState))
                return .none

            case .router(.routeAction(id: _, action: .saveURLCoordinator(.goBackToHome))):
                state.routes.goBack()
                return .none

            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
