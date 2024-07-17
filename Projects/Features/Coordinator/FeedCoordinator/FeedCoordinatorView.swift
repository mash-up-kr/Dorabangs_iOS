//
//  FeedCoordinatorView.swift
//  FeedCoordinator
//
//  Created by 박소현 on 6/29/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ChangeFolderName
import ComposableArchitecture
import Feed
import StorageBox
import SwiftUI
import TCACoordinators

public struct FeedCoordinatorView: View {
    private let store: StoreOf<FeedCoordinator>

    public init(store: StoreOf<FeedCoordinator>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
                switch screen.case {
                case let .feed(store):
                    FeedView(store: store)
                case let .changeFolderName(store):
                    ChangeFolderNameView(store: store)
                        .navigationBarHidden(true)
                        .navigationTitle("")
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
    }
}
