//
//  TabCoordinator.swift
//  TabCoordinator
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Foundation
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
        var clipboardToast = ClipboardToastFeature.State()
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

    public enum Action {
        case home(HomeCoordinator.Action)
        case storageBox(StorageBoxCoordinator.Action)
        case clipboardToast(ClipboardToastFeature.Action)
        case tabSelected(Tab)

        case deeplink(postId: String, url: URL)
        case clipboardURLChanged(URL)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.home, action: \.home) {
            HomeCoordinator()
        }
        Scope(state: \.storageBox, action: \.storageBox) {
            StorageBoxCoordinator()
        }
        Scope(state: \.clipboardToast, action: \.clipboardToast) {
            ClipboardToastFeature()
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

            case let .clipboardURLChanged(url):
                switch state.selectedTab {
                case .home:
                    return Effect.concatenate(
                        HomeCoordinator()
                            .reduce(into: &state.home, action: .router(.routeAction(id: 0, action: .home(.setIsAddLinkButtonShowed(false)))))
                            .map(Action.home),
                        ClipboardToastFeature()
                            .reduce(into: &state.clipboardToast, action: .presentToast(url))
                            .map(Action.clipboardToast)
                    )
                case .storageBox:
                    return ClipboardToastFeature()
                        .reduce(into: &state.clipboardToast, action: .presentToast(url))
                        .map(Action.clipboardToast)
                }

            case let .deeplink(postId, url):
                return routeToChangeFolderScene(state: &state, postId: postId, url: url)

            case .clipboardToast(.saveButtonTapped):
                guard let url = URL(string: state.clipboardToast.shared.urlString) else { return .none }
                return routeToSelectFolderScene(state: &state, with: url)

            case let .clipboardToast(.isPresentedChanged(isPresented)):
                guard state.selectedTab == .home else { return .none }
                let isAddLinkButtonShowed = !isPresented
                return HomeCoordinator()
                    .reduce(into: &state.home, action: .router(.routeAction(id: 0, action: .home(.setIsAddLinkButtonShowed(isAddLinkButtonShowed)))))
                    .map(Action.home)

            default:
                return .none
            }
        }
    }
}

extension TabCoordinator {
    func routeToSelectFolderScene(state: inout State, with url: URL) -> Effect<Action> {
        switch state.selectedTab {
        case .home:
            HomeCoordinator()
                .reduce(into: &state.home, action: .routeToSaveURLCoordinator(.selectFolder(.init(saveURL: url))))
                .map(Action.home)

        case .storageBox:
            StorageBoxCoordinator()
                .reduce(into: &state.storageBox, action: .routeToSaveURLCoordinator(.selectFolder(.init(saveURL: url))))
                .map(Action.storageBox)
        }
    }

    func routeToChangeFolderScene(state: inout State, postId: String, url: URL) -> Effect<Action> {
        switch state.selectedTab {
        case .home:
            HomeCoordinator()
                .reduce(into: &state.home, action: .routeToSaveURLCoordinator(.changeFolder(.init(postId: postId, url: url))))
                .map(Action.home)

        case .storageBox:
            StorageBoxCoordinator()
                .reduce(into: &state.storageBox, action: .routeToSaveURLCoordinator(.changeFolder(.init(postId: postId, url: url))))
                .map(Action.storageBox)
        }
    }
}
