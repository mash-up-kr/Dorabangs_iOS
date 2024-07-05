//
//  TabCoordinator.swift
//  TabCoordinator
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import HomeCoordinator
import StorageBoxCoordinator
import TCACoordinators

@Reducer
public struct TabCoordinator {
    public enum Tab: Hashable {
        case home
        case storageBox
    }

    @ObservableState
    public struct State: Equatable {
        public static let initialState = State(
            home: .initialState,
            storageBox: .initialState,
            selectedTab: .home
        )
        var home: HomeCoordinator.State
        var storageBox: StorageBoxCoordinator.State
        var selectedTab: Tab

        public init(
            home: HomeCoordinator.State,
            storageBox: StorageBoxCoordinator.State,
            selectedTab: Tab
        ) {
            self.home = home
            self.storageBox = storageBox
            self.selectedTab = selectedTab
        }
    }

    public enum Deeplink {
        case homeCoodinator(HomeCoordinator.Deeplink)
    }

    public enum Action {
        case home(HomeCoordinator.Action)
        case storageBox(StorageBoxCoordinator.Action)
        case tabSelected(Tab)
        case deeplink(Deeplink)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.home, action: \.home) {
            HomeCoordinator()
        }
        Scope(state: \.storageBox, action: \.storageBox) {
            StorageBoxCoordinator()
        }
        Reduce { state, action in
            switch action {
            case .home:
                return .none

            case .storageBox:
                return .none

            case let .tabSelected(tab):
                state.selectedTab = tab
                return .none

            case let .deeplink(.homeCoodinator(deeplink)):
                state.selectedTab = .home
                return HomeCoordinator()
                    .reduce(into: &state.home, action: .deeplink(deeplink))
                    .map(Action.home)
            }
        }
    }
}
