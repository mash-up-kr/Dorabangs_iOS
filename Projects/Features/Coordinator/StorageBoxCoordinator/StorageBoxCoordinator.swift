//
//  StorageBoxCoordinator.swift
//  StorageBoxCoordinator
//
//  Created by 김영균 on 6/14/24.
//

import ComposableArchitecture
import StorageBox
import TCACoordinators

@Reducer(state: .equatable)
public enum StorageBoxScreen {
    case storageBox(StorageBox)
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
        Reduce { _, action in
            switch action {
            default:
                .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
