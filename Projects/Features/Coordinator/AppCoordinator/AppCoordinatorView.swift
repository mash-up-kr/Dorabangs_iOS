//
//  AppCoordinatorView.swift
//  AppCoordinator
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Onboarding
import Splash
import SwiftUI
import TabCoordinator
import TCACoordinators

public struct AppCoordinatorView: View {
    private let store: StoreOf<AppCoordinator>

    public init(store: StoreOf<AppCoordinator>) {
        self.store = store
    }

    public var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            switch screen.case {
            case let .onboarding(store):
                OnboardingView(store: store)
                    .navigationBarHidden(true)
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)

            case let .splash(store):
                SplashView(store: store)

            case let .tabCoordinator(store):
                TabCoordinatorView(store: store)
                    .navigationBarHidden(true)
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
