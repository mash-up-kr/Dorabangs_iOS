//
//  AppCoordinator.swift
//  AppCoordinator
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Onboarding
import Splash
import TabCoordinator
import TCACoordinators

@Reducer(state: .equatable)
public enum AppScreen {
    case onboarding(Onboarding)
    case splash(Splash)
    case tabCoordinator(TabCoordinator)
}

@Reducer
public struct AppCoordinator {
    @ObservableState
    public struct State: Equatable {
        public static let initialState = State(
            routes: [.root(.splash(.init()), embedInNavigationView: false)]
        )
        var routes: [Route<AppScreen.State>]

        public init(routes: [Route<AppScreen.State>]) {
            self.routes = routes
        }
    }

    public enum Action {
        case router(IndexedRouterActionOf<AppScreen>)
        case saveURL(URL)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .router(.routeAction(id: _, action: .splash(.routeToOnboardingScreen))):
                state.routes = [.root(.onboarding(.initialState), embedInNavigationView: false)]
                return .none

            case .router(.routeAction(id: _, action: .splash(.routeToTabCoordinatorScreen))):
                state.routes = [.root(.tabCoordinator(.initialState), embedInNavigationView: true)]
                return .none

            case .router(.routeAction(id: _, action: .onboarding(.routeToTabCoordinatorScreen))):
                state.routes = [.root(.tabCoordinator(.initialState), embedInNavigationView: true)]
                return .none

            case let .saveURL(url):
                state.routes = [.root(.tabCoordinator(.initialState), embedInNavigationView: true)]
                let deeplink = TabCoordinator.Deeplink.homeCoodinator(.saveURL(url))
                return .send(.router(.routeAction(id: 0, action: .tabCoordinator(.deeplink(deeplink)))))

            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
