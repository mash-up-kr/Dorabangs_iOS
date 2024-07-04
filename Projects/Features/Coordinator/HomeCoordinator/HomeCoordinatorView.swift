//
//  HomeCoordinatorView.swift
//  HomeCoordinator
//
//  Created by 김영균 on 6/14/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Home
import SaveURLCoordinator
import SwiftUI
import TCACoordinators

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
                VStack(spacing: 0) {
                    HomeView(store: store)
                    tabbar()
                }
                .navigationBarHidden(true)

            case let .saveURLCoordinator(store):
                SaveURLCoordinatorView(store: store)
                    .navigationBarHidden(true)
            }
        }
    }
}
