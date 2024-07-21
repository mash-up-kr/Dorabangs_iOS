//
//  AIClassificationCoordinator.swift
//  AppCoordinator
//
//  Created by 김영균 on 7/20/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import AIClassification
import ComposableArchitecture
import FeedCoordinator
import TCACoordinators

@Reducer(state: .equatable)
public enum AIClassificationScreen {
    case aiClassification(AIClassification)
    case feedCoordinator(FeedCoordinator)
}

@Reducer
public struct AIClassificationCoordinator {
    @ObservableState
    public struct State: Equatable {
        public static let initialState = State(routes: [.root(.aiClassification(.initialState), embedInNavigationView: true)])
        var routes: [Route<AIClassificationScreen.State>]

        public init(routes: [Route<AIClassificationScreen.State>]) {
            self.routes = routes
        }
    }

    public enum Action {
        case router(IndexedRouterActionOf<AIClassificationScreen>)
        case routeToPreviousScreen
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .router(.routeAction(id: _, action: .aiClassification(.routeToHomeScreen))):
                return .send(.routeToPreviousScreen)

            case let .router(.routeAction(id: _, action: .aiClassification(.routeToFeedScreen(folder)))):
                state.routes.push(.feedCoordinator(.init(folder)))
                return .none

            case .router(.routeAction(id: _, action: .feedCoordinator(.routeToPreviousScreen))):
                state.routes.goBack()
                return .none

            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
