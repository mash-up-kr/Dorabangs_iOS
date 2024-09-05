//
//  FeedCoordinator.swift
//  AppCoordinator
//
//  Created by 박소현 on 6/29/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ChangeFolderName
import ComposableArchitecture
import CreateNewFolder
import Feed
import Models
import TCACoordinators
import Web

@Reducer(state: .equatable)
public enum FeedScreen {
    case feed(Feed)
    case changeFolderName(ChangeFolderName)
    case web(Web)
    case createNewFolder(CreateNewFolder)
}

@Reducer
public struct FeedCoordinator {
    @ObservableState
    public struct State: Equatable {
        var routes: [Route<FeedScreen.State>]

        public init(routes: [Route<FeedScreen.State>]) {
            self.routes = routes
        }

        public init(_ folder: Folder, feedViewType: FeedViewType = .all) {
            routes = [.root(
                .feed(
                    .init(
                        currentFolder: folder,
                        feedViewType: feedViewType
                    )
                ),
                embedInNavigationView: true
            )]
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
            case let .router(.routeAction(id: _, action: .feed(action))):
                return handleFeedAction(into: &state, action: action)
            case .router(.routeAction(id: _, action: .changeFolderName(.routeToPreviousScreen))):
                state.routes.goBack()
                return .none
            case .router(.routeAction(id: _, action: .changeFolderName(.routeToStorageBox(let patchedFolder)))):
                state.routes.goBack()
                return .send(.router(.routeAction(id: 0, action: .feed(.changedFolderName(patchedFolder)))))
            case .router(.routeAction(id: _, action: .web(.routeToPreviousScreen))):
                state.routes.goBack()
                return .none
            case .router(.routeAction(id: _, action: .createNewFolder(.routeToFeedScene))):
                guard let folderName = state.routes.last?.screen.createNewFolder.map(\.newFolderName) else { return .none }
                state.routes.goBack()
                return .send(.router(.routeAction(id: 0, action: .feed(.movedFolderResult(folderName: folderName)))))
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}

public extension FeedCoordinator {
    func handleFeedAction(into state: inout State, action: Feed.Action) -> Effect<Action> {
        switch action {
        case .routeToPreviousScreen:
            return .send(.routeToPreviousScreen)
        case let .routeToChangeFolderName(folderId):
            state.routes.push(.changeFolderName(.init(folderID: folderId, folders: [])))
            return .none
        case let .routeToCreateNewFolderScene(postId):
            state.routes.push(.createNewFolder(.init(sourceView: .feed, postId: postId)))
            return .none
        case .removeFolderResult:
            return .send(.routeToPreviousScreen)
        case let .routeToWebScreen(url):
            state.routes.push(.web(.init(url: url)))
            return .none
        default:
            return .none
        }
    }
}
