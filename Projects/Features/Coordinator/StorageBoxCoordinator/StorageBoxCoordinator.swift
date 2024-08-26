//
//  StorageBoxCoordinator.swift
//  StorageBoxCoordinator
//
//  Created by 김영균 on 6/14/24.
//

import ChangeFolderName
import ComposableArchitecture
import CreateNewFolder
import FeedCoordinator
import Foundation
import LocalizationKit
import SaveURLCoordinator
import StorageBox
import TCACoordinators

@Reducer(state: .equatable)
public enum StorageBoxScreen {
    case saveURLCoordinator(SaveURLCoordinator)
    case storageBox(StorageBox)
    case feed(FeedCoordinator)
    case changeFolderName(ChangeFolderName)
    case createNewFolder(CreateNewFolder)
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
        case routeToSaveURLCoordinator(SaveURLScreen.State)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .router(.routeAction(id: _,
                                      action: .storageBox(.routeToFeed(let folder)))):
                state.routes.push(.feed(.init(routes: [.root(.feed(.init(currentFolder: folder)), embedInNavigationView: true)])))
                return .none
            case .router(.routeAction(id: _, action: .storageBox(.routeToChangeFolderName(let folderID, let folderNames)))):
                state.routes.push(.changeFolderName(.init(folderID: folderID, folders: folderNames)))
                return .none
            case .router(.routeAction(id: _, action: .changeFolderName(.routeToPreviousScreen))):
                state.routes.goBack()
                return .none
            case .router(.routeAction(id: _, action: .feed(.routeToPreviousScreen))):
                state.routes.goBack()
                return .none
            case .router(.routeAction(id: _, action: .changeFolderName(.routeToStorageBox(let patchedFolder)))):
                state.routes.goBack()
                return .send(.router(.routeAction(id: 0, action: .storageBox(.changedFolderName(patchedFolder)))))
            case .router(.routeAction(id: 0, action: .saveURLCoordinator(.routeToPreviousScreen))):
                state.routes.goBack()
                return .none
            case .router(.routeAction(id: _, action: .storageBox(.routeToCreateNewFolderScene))):
                state.routes.push(.createNewFolder(.init(sourceView: .storageBox)))
                return .none
            case let .router(.routeAction(id: _, action: .createNewFolder(action))):
                return handleCreateNewFolderSceneAction(into: &state, action: action)
            case let .router(.routeAction(id: _, action: .saveURLCoordinator(action))):
                return handleSaveURLCoordinatorAction(into: &state, action: action)
            case let .routeToSaveURLCoordinator(screen):
                let routes: [Route<SaveURLScreen.State>] = [.root(screen, embedInNavigationView: true)]
                state.routes.push(.saveURLCoordinator(.init(routes: routes)))
                return .none
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}

extension StorageBoxCoordinator {
    func handleSaveURLCoordinatorAction(into state: inout State, action: SaveURLCoordinator.Action) -> Effect<Action> {
        switch action {
        case .routeToPreviousScreen:
            state.routes.goBack()
            return .none

        default:
            return .none
        }
    }

    func handleCreateNewFolderSceneAction(into state: inout State, action: CreateNewFolder.Action) -> Effect<Action> {
        switch action {
        case .routeToStorageBoxScene:
            state.routes.goBack()
            let showToast = StorageBox.Action.showToast(message: LocalizationKitStrings.Common.folderCreatedToastMessage)
            return .send(.router(.routeAction(id: 0, action: .storageBox(showToast))))

        case .routeToPreviousScreen:
            state.routes.goBack()
            return .none

        default:
            return .none
        }
    }
}
