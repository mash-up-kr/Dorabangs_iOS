//
//  HomeCoordinatorView.swift
//  HomeCoordinator
//
//  Created by 김영균 on 6/14/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Home
import SwiftUI
import TCACoordinators

public struct HomeCoordinatorView: View {
    private let store: StoreOf<HomeCoordinator>

    public init(store: StoreOf<HomeCoordinator>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
                switch screen.case {
                case let .home(store):
                    HomeView(store: store)
                }
            }
        }
    }
}
