//
//  FolderCoordinator.swift
//  FolderCoordinator
//
//  Created by 김영균 on 6/14/24.
//

import ComposableArchitecture
import Folder
import TCACoordinators

@Reducer(state: .equatable)
public enum FolderScreen {
    case folder(Folder)
}

@Reducer
public struct FolderCoordinator {
    @ObservableState
    public struct State: Equatable {
        public static let initialState = State(routes: [.root(.folder(.initialState), embedInNavigationView: true)])
        var routes: [Route<FolderScreen.State>]
        
        public init(routes: [Route<FolderScreen.State>]) {
            self.routes = routes
        }
    }
    
    public enum Action {
        case router(IndexedRouterActionOf<FolderScreen>)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
        .forEachRoute(\.routes, action: \.router)
    }
}
