//
//  FeedCoordinator.swift
//  AppCoordinator
//
//  Created by 박소현 on 6/29/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ChangeFolderName
import ComposableArchitecture
import Feed
import Models
import TCACoordinators

@Reducer(state: .equatable)
public enum FeedScreen {
    case feed(Feed)
    case changeFolderName(ChangeFolderName)
}

@Reducer
public struct FeedCoordinator {
    @ObservableState
    public struct State: Equatable {
        var routes: [Route<FeedScreen.State>]

        public init(routes: [Route<FeedScreen.State>]) {
            self.routes = routes
        }

        public init(_ folder: Folder) {
            routes = [.root(.feed(.init(currentFolder: folder)), embedInNavigationView: true)]
        }
    }

    public enum Action {
        case router(IndexedRouterActionOf<FeedScreen>)
        case routeToPreviousScreen
        case removeFolder(String)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .router(.routeAction(id: _, action: .feed(.routeToPreviousScreen))):
                return .send(.routeToPreviousScreen)
            case .router(.routeAction(id: _, action: .feed(.removeFolder))):
                return .send(.routeToPreviousScreen)
            case .router(.routeAction(id: _, action:
                // TODO: - folderID담아가는 걸로 수정해야함
                .feed(.routeToChangeFolderName(let folderTitle)))):
                state.routes.push(.changeFolderName(.init(folderID: "", folders: [folderTitle])))
                return .none
            case .router(.routeAction(id: _, action: .changeFolderName(.routeToPreviousScreen))):
                state.routes.goBack()
                return .none
            case .router(.routeAction(id: _, action: .changeFolderName(.routeToStorageBox(let patchedFolder)))):
                state.routes.goBack()
                // TODO: - routeFeed 만들어야함
                return .send(.router(.routeAction(id: 0, action: .feed(.changedFolderName(patchedFolder)))))
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
