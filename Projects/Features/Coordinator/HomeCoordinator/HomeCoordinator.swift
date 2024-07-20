//
//  HomeCoordinator.swift
//  HomeCoordinator
//
//  Created by 김영균 on 6/14/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import AIClassification
import ComposableArchitecture
import CreateNewFolder
import Foundation
import Home
import SaveURLCoordinator
import TCACoordinators

@Reducer(state: .equatable)
public enum HomeScreen {
    case home(Home)
    case saveURLCoordinator(SaveURLCoordinator)
    case createNewFolder(CreateNewFolder)
    case aiClassification(AIClassification)
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
            case let .router(.routeAction(id: _, action: .home(action))):
                return handleHomeAction(into: &state, action: action)

            case let .router(.routeAction(id: _, action: .saveURLCoordinator(action))):
                return handleSaveURLCoordinatorAction(into: &state, action: action)

            case let .router(.routeAction(id: _, action: .createNewFolder(action))):
                return handleCreateNewFolderAction(into: &state, action: action)

            case let .router(.routeAction(id: _, action: .aiClassification(action))):
                return handleAIClassificationAction(into: &state, action: action)

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

public extension HomeCoordinator {
    func handleHomeAction(into state: inout State, action: Home.Action) -> Effect<Action> {
        switch action {
        case .addLinkButtonTapped:
            let routes: [Route<SaveURLScreen.State>] = [.root(.saveURL(.initialState), embedInNavigationView: true)]
            let saveURLCoordinator = SaveURLCoordinator.State(routes: routes)
            state.routes.push(.saveURLCoordinator(saveURLCoordinator))
            return .none

        case let .routeToSelectFolder(saveURL):
            state.routes.push(.saveURLCoordinator(.init(routeToSelectFolder: saveURL)))
            return .none

        case let .overlayComponent(.routeToCreateNewFolderScreen(folders)):
            state.routes.push(.createNewFolder(.init(folders: folders)))
            return .none

        case .routeToAIClassificationScreen:
            state.routes.push(.aiClassification(.initialState))
            return .none

        default:
            return .none
        }
    }

    func handleSaveURLCoordinatorAction(into state: inout State, action: SaveURLCoordinator.Action) -> Effect<Action> {
        switch action {
        case .routeToHomeScreen:
            state.routes.goBack()
            return .none

        default:
            return .none
        }
    }

    func handleCreateNewFolderAction(into state: inout State, action: CreateNewFolder.Action) -> Effect<Action> {
        switch action {
        case .routeToPreviousScreen:
            state.routes.goBack()
            let action = HomeScreen.Action.home(.overlayComponent(.isSelectFolderBottomSheetPresentedChanged(true)))
            return .send(.router(.routeAction(id: 0, action: action)))

        case .routeToHomeScreen:
            guard let folderName = state.routes.last?.screen.createNewFolder.map(\.newFolderName) else { return .none }
            state.routes.goBack()
            let action = HomeScreen.Action.home(.overlayComponent(.presentToast(toastMessage: "\(folderName)(으)로 이동했어요.")))
            return .send(.router(.routeAction(id: 0, action: action)))

        default:
            return .none
        }
    }

    func handleAIClassificationAction(into state: inout State, action: AIClassification.Action) -> Effect<Action> {
        switch action {
        case .routeToHomeScreen:
            state.routes.goBack()
            return .none

        default:
            return .none
        }
    }
}
