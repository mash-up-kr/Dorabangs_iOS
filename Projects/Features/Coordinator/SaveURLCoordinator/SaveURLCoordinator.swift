//
//  SaveURLCoordinator.swift
//  UrlSaveCoordinator
//
//  Created by 김영균 on 6/29/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import CreateNewFolder
import Foundation
import SaveURL
import SelectFolder
import TCACoordinators

@Reducer(state: .equatable)
public enum SaveURLScreen {
    case createNewFolder(CreateNewFolder)
    case saveURL(SaveURL)
    case selectFolder(SelectFolder)
}

@Reducer
public struct SaveURLCoordinator {
    @ObservableState
    public struct State: Equatable {
        var routes: [Route<SaveURLScreen.State>]

        public init(routes: [Route<SaveURLScreen.State>]) {
            self.routes = routes
        }

        /// 홈에서 클립보드 토스트를 통해 폴더 선택 화면으로 이동할 때 사용
        public init(routeToSelectFolder saveURL: URL) {
            routes = [.root(.selectFolder(.init(saveURL: saveURL)), embedInNavigationView: true)]
        }
    }

    public enum Action {
        case router(IndexedRouterActionOf<SaveURLScreen>)
        case goBackToHome
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .router(.routeAction(id: _, action: .saveURL(.routeToPreviousScreen))):
                return .send(.goBackToHome)

            case let .router(.routeAction(id: _, action: .saveURL(.routeToSelectFolderScreen(saveURL)))):
                state.routes.push(.selectFolder(.init(saveURL: saveURL)))
                return .none

            case .router(.routeAction(id: _, action: .selectFolder(.routeToPreviousScreen))):
                if state.routes.count > 1 {
                    state.routes.goBack()
                    return .none
                } else {
                    return .send(.goBackToHome)
                }

            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
