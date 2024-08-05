//
//  AIClassificationCoordinatorView.swift
//  AppCoordinator
//
//  Created by 김영균 on 7/20/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import AIClassification
import ComposableArchitecture
import FeedCoordinator
import SwiftUI
import TCACoordinators

public struct AIClassificationCoordinatorView: View {
    private let store: StoreOf<AIClassificationCoordinator>

    public init(store: StoreOf<AIClassificationCoordinator>) {
        self.store = store
    }

    public var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            switch screen.case {
            case let .aiClassification(store):
                AIClassificationView(store: store)
                    .navigationBarHidden(true)
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)

            case let .feedCoordinator(store):
                FeedCoordinatorView(store: store)
                    .navigationBarHidden(true)
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
