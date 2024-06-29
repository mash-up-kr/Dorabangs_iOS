//
//  StorageBoxCoordinatorView.swift
//  StorageBoxCoordinator
//
//  Created by 김영균 on 6/14/24.
//

import ComposableArchitecture
import StorageBox
import SwiftUI
import TCACoordinators
import FeedCoordinator

public struct StorageBoxCoordinatorView: View {
    private let store: StoreOf<StorageBoxCoordinator>

    public init(store: StoreOf<StorageBoxCoordinator>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
                switch screen.case {
                case let .storageBox(store):
                    StorageBoxView(store: store)
                case let .feed(store):
                    FeedCoordinatorView(store: store)
                }
            }
        }
    }
}
