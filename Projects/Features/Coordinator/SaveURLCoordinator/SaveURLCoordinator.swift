//
//  SaveURLCoordinator.swift
//  UrlSaveCoordinator
//
//  Created by 김영균 on 6/29/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import CreateNewFolder
import SaveURL
import TCACoordinators

@Reducer(state: .equatable)
public enum SaveURLScreen {
    case createNewFolder(CreateNewFolder)
    case saveURL(SaveURL)
}

@Reducer
public struct SaveURLCoordinator {
    @ObservableState
    public struct State: Equatable {
        public static let initialState = State(routes: [.root(.saveURL(.initialState), embedInNavigationView: false)])
        var routes: [Route<SaveURLScreen.State>]

        public init(routes: [Route<SaveURLScreen.State>]) {
            self.routes = routes
        }
    }

    public enum Action {
        case router(IndexedRouterActionOf<SaveURLScreen>)
        case goBackToHome
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .router(.routeAction(id: _, action: .saveURL(.backButtonTapped))):
                .send(.goBackToHome)

            default:
                .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
