//
//  HomeCoordinator.swift
//  HomeCoordinator
//
//  Created by 김영균 on 6/14/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Foundation
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
        public static let initialState = State(routes: [.root(.home(.initialState), embedInNavigationView: true)])
        var routes: [Route<HomeScreen.State>]

        public init(routes: [Route<HomeScreen.State>]) {
            self.routes = routes
        }
    }

    public enum Deeplink {
        case saveURL(URL)
    }

    public enum Action {
        case router(IndexedRouterActionOf<HomeScreen>)
        case deeplink(Deeplink)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .router(.routeAction(id: _, action: .home(.addLinkButtonTapped))):
                let routes: [Route<SaveURLScreen.State>] = [.root(.saveURL(.initialState), embedInNavigationView: true)]
                let saveURLCoordinator = SaveURLCoordinator.State(routes: routes)
                state.routes.push(.saveURLCoordinator(saveURLCoordinator))
                return .none

            case .router(.routeAction(id: _, action: .saveURLCoordinator(.routeToHomeScreen))):
                state.routes.goBack()
                return .none

            case let .router(.routeAction(id: _, action: .home(.routeToSelectFolder(saveURL)))):
                state.routes.push(.saveURLCoordinator(.init(routeToSelectFolder: saveURL)))
                return .none

            case let .deeplink(.saveURL(saveURL)):
                state.routes = [
                    .root(.home(.initialState), embedInNavigationView: true),
                    .push(.saveURLCoordinator(.init(routeToSelectFolder: saveURL)))
                ]
                return .none

            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
