//
//  FeedCoordinatorView.swift
//  FeedCoordinator
//
//  Created by 박소현 on 6/29/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ChangeFolderName
import ComposableArchitecture
import CreateNewFolder
import Feed
import StorageBox
import SwiftUI
import TCACoordinators
import WebViewCoordinator

public struct FeedCoordinatorView: View {
    private let store: StoreOf<FeedCoordinator>

    public init(store: StoreOf<FeedCoordinator>) {
        self.store = store
    }

    public var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            switch screen.case {
            case let .feed(store):
                FeedView(store: store)
                    .navigationBarHidden(true)
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)
            case let .changeFolderName(store):
                ChangeFolderNameView(store: store)
                    .navigationBarHidden(true)
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)
            case let .webViewCoordinator(store):
                WebViewCoordinatorView(store: store)
                    .navigationBarHidden(true)
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)
            case let .createNewFolder(store):
                CreateNewFolderView(store: store)
                    .navigationBarHidden(true)
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
