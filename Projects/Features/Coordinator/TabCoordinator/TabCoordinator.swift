//
//  TabCoordinator.swift
//  TabCoordinator
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import FolderCoordinator
import HomeCoordinator
import TCACoordinators

@Reducer
public struct TabCoordinator {
    public enum Tab: Hashable {
        case home
        case folder
    }
    
    @ObservableState
    public struct State: Equatable {
        public static let initialState = State(
            home: .initialState,
            folder: .initialState,
            selectedTab: .home
        )
        var home: HomeCoordinator.State
        var folder: FolderCoordinator.State
        var selectedTab: Tab
        
        public init(
            home: HomeCoordinator.State,
            folder: FolderCoordinator.State,
            selectedTab: Tab
        ) {
            self.home = home
            self.folder = folder
            self.selectedTab = selectedTab
        }
    }
    
    public enum Action {
        case home(HomeCoordinator.Action)
        case folder(FolderCoordinator.Action)
        case tabSelected(Tab)
    }
    
    public init() {}
    
    public var body: some ReducerOf<Self> {
        Scope(state: \.home, action: \.home) {
            HomeCoordinator()
        }
        Scope(state: \.folder, action: \.folder) {
            FolderCoordinator()
        }
        Reduce { state, action in
            switch action {
            case .home:
                return .none
                
            case .folder:
                return .none
                
            case let .tabSelected(tab):
                state.selectedTab = tab
                return .none
            }
        }
    }
}
