//
//  WebViewCoordinator.swift
//  WebViewCoordinator
//
//  Created by 김영균 on 9/23/24.
//

import AISummary
import ComposableArchitecture
import TCACoordinators
import Web

@Reducer(state: .equatable)
public enum WebViewScreen {
    case web(Web)
    case aiSummary(AISummary)
}

@Reducer
public struct WebViewCoordinator {
    @ObservableState
    public struct State: Equatable {
        var routes: [Route<WebViewScreen.State>]

        public init(webScreen: Web.State) {
            routes = [.root(.web(webScreen), embedInNavigationView: true)]
        }

        public init(routes: [Route<WebViewScreen.State>]) {
            self.routes = routes
        }
    }

    public enum Action {
        case router(IndexedRouterActionOf<WebViewScreen>)
        case routeToPreviousScreen
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .router(.routeAction(id: _, action: .web(action))):
                handleWebAction(into: &state, action: action)

            case let .router(.routeAction(id: _, action: .aiSummary(action))):
                handleAISummaryAction(into: &state, action: action)

            default:
                .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}

extension WebViewCoordinator {
    func handleWebAction(into state: inout State, action: Web.Action) -> Effect<Action> {
        switch action {
        case .routeToPreviousScreen:
            return .send(.routeToPreviousScreen)

        case let .routeToAISummaryScreen(aiSummary, tags):
            state.routes.push(.aiSummary(.init(aiSummary: aiSummary, tags: tags)))
            return .none

        default:
            return .none
        }
    }

    func handleAISummaryAction(into state: inout State, action: AISummary.Action) -> Effect<Action> {
        switch action {
        case .routeToPreviousScreen:
            state.routes.goBack()
            return .none

        default:
            return .none
        }
    }
}
