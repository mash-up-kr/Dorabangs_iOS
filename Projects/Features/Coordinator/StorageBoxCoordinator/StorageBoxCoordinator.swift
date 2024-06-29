//
//  StorageBoxCoordinator.swift
//  StorageBoxCoordinator
//
//  Created by 김영균 on 6/14/24.
//

import ComposableArchitecture
import StorageBox
import TCACoordinators
import FeedCoordinator

@Reducer(state: .equatable)
public enum StorageBoxScreen {
    case storageBox(StorageBox)
    case feed(FeedCoordinator)
}

@Reducer
public struct StorageBoxCoordinator {
    @ObservableState
    public struct State: Equatable {
        public static let initialState = State(routes: [.root(.storageBox(.initialState), embedInNavigationView: true)])
        var routes: [Route<StorageBoxScreen.State>]

        public init(routes: [Route<StorageBoxScreen.State>]) {
            self.routes = routes
        }
    }

    public enum Action {
        case router(IndexedRouterActionOf<StorageBoxScreen>)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .router(.routeAction(id: _, action: .storageBox(.storageBoxTapped))):
                state.routes.push(.feed(.initialState))
                return .none
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
