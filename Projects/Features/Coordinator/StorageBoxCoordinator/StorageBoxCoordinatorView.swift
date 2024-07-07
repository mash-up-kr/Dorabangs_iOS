//
//  StorageBoxCoordinatorView.swift
//  StorageBoxCoordinator
//
//  Created by 김영균 on 6/14/24.
//

import ChangeFolderName
import ComposableArchitecture
import FeedCoordinator
import StorageBox
import SwiftUI
import TCACoordinators

public struct StorageBoxCoordinatorView<Content: View>: View {
    private let store: StoreOf<StorageBoxCoordinator>
    private let tabbar: () -> Content

    public init(
        store: StoreOf<StorageBoxCoordinator>,
        tabbar: @autoclosure @escaping () -> Content
    ) {
        self.store = store
        self.tabbar = tabbar
    }

    public var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            switch screen.case {
            case let .storageBox(store):
                StorageBoxContainerView(store: store, tabbar: tabbar())
                    .navigationBarHidden(true)
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)

            case let .feed(store):
                FeedCoordinatorView(store: store)
                    .navigationBarHidden(true)
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)

            case let .changeFolderName(store):
                ChangeFolderNameView(store: store)
                    .navigationBarHidden(true)
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
