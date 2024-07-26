//
//  HomeCoordinatorView.swift
//  HomeCoordinator
//
//  Created by 김영균 on 6/14/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import AIClassificationCoordinator
import ComposableArchitecture
import CreateNewFolder
import Home
import SaveURLCoordinator
import SaveURLVideoGuide
import SwiftUI
import TCACoordinators
import Web

public struct HomeCoordinatorView<Content: View>: View {
    private let store: StoreOf<HomeCoordinator>
    private let tabbar: () -> Content

    public init(
        store: StoreOf<HomeCoordinator>,
        tabbar: @autoclosure @escaping () -> Content
    ) {
        self.store = store
        self.tabbar = tabbar
    }

    public var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            switch screen.case {
            case let .home(store):
                HomeContainerView(store: store, tabbar: tabbar())
                    .navigationBarHidden(true)
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)

            case let .saveURLCoordinator(store):
                SaveURLCoordinatorView(store: store)
                    .navigationBarHidden(true)
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)

            case let .createNewFolder(store):
                CreateNewFolderView(store: store)
                    .navigationBarHidden(true)
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)

            case let .aiClassificationCoordinator(store):
                AIClassificationCoordinatorView(store: store)
                    .navigationBarHidden(true)
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)

            case let .saveURLVideoGuide(store):
                SaveURLVideoGuideView(store: store)
                    .navigationBarHidden(true)
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)

            case let .web(store):
                WebView(store: store)
                    .navigationBarHidden(true)
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
