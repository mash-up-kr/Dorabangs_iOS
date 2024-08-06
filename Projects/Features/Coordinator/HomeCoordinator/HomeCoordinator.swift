//
//  HomeCoordinator.swift
//  HomeCoordinator
//
//  Created by 김영균 on 6/14/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import AIClassificationCoordinator
import ComposableArchitecture
import CreateNewFolder
import FeedCoordinator
import Foundation
import Home
import LocalizationKit
import Models
import SaveURLCoordinator
import SaveURLVideoGuide
import TCACoordinators
import Web

@Reducer(state: .equatable)
public enum HomeScreen {
    case home(Home)
    case saveURLCoordinator(SaveURLCoordinator)
    case createNewFolder(CreateNewFolder)
    case aiClassificationCoordinator(AIClassificationCoordinator)
    case feedCoordinator(FeedCoordinator)
    case saveURLVideoGuide(SaveURLVideoGuide)
    case web(Web)
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

    public enum Action {
        case router(IndexedRouterActionOf<HomeScreen>)
        case routeToSaveURLCoordinator(url: URL)
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

            case let .router(.routeAction(id: _, action: .aiClassificationCoordinator(action))):
                return handleAIClassificationCoordinatorAction(into: &state, action: action)

            case let .router(.routeAction(id: _, action: .feedCoordinator(action))):
                return handleFeedCoordinatorAction(into: &state, action: action)

            case let .router(.routeAction(id: _, action: .saveURLVideoGuide(action))):
                return handleSaveURLVideoGuideAction(into: &state, action: action)

            case let .router(.routeAction(id: _, action: .web(action))):
                return handleWebAction(into: &state, action: action)

            case let .routeToSaveURLCoordinator(url):
                state.routes.push(.saveURLCoordinator(.init(routeToSelectFolder: url)))
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

        case .overlayComponent(.routeToCreateNewFolderScreen):
            state.routes.push(.createNewFolder(.init(sourceView: .homeScene)))
            return .none

        case .routeToAIClassificationScreen:
            state.routes.push(.aiClassificationCoordinator(.initialState))
            return .none

        case .routeToUnreadFeed:
            state.routes.push(.feedCoordinator(.init(Folder(id: "", name: "", type: .all, postCount: 6))))
            return .none

        case .routeToSaveURLVideoGuideScreen:
            state.routes.push(.saveURLVideoGuide(.initialState))
            return .none

        case let .routeToWebScreen(url):
            state.routes.push(.web(.init(url: url)))
            return .none

        default:
            return .none
        }
    }

    func handleSaveURLCoordinatorAction(into state: inout State, action: SaveURLCoordinator.Action) -> Effect<Action> {
        switch action {
        case .routeToPreviousScreen:
            state.routes.goBack()
            return .none

        case .routeToHomeScreen:
            state.routes.goBack()
            let toastAction = Home.Action.overlayComponent(.presentToast(toastMessage: LocalizationKitStrings.Common.linkSaved))
            return .send(.router(.routeAction(id: 0, action: .home(toastAction))))

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
            let action = HomeScreen.Action.home(.overlayComponent(.presentToast(toastMessage: LocalizationKitStrings.Common.folderMovedToastMessage(folderName))))
            return .send(.router(.routeAction(id: 0, action: action)))

        default:
            return .none
        }
    }

    func handleAIClassificationCoordinatorAction(into state: inout State, action: AIClassificationCoordinator.Action) -> Effect<Action> {
        switch action {
        case .routeToPreviousScreen:
            state.routes.goBack()
            return .none

        default:
            return .none
        }
    }

    func handleFeedCoordinatorAction(into state: inout State, action: FeedCoordinator.Action) -> Effect<Action> {
        switch action {
        case .routeToPreviousScreen:
            state.routes.goBack()
            return .none

        default:
            return .none
        }
    }

    func handleSaveURLVideoGuideAction(into state: inout State, action: SaveURLVideoGuide.Action) -> Effect<Action> {
        switch action {
        case .routeToPreviousScreen:
            state.routes.goBack()
            return .none

        default:
            return .none
        }
    }

    func handleWebAction(into state: inout State, action: Web.Action) -> Effect<Action> {
        switch action {
        case .routeToPreviousScreen:
            state.routes.goBack()
            return .none

        default:
            return .none
        }
    }
}
