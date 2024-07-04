//
//  SaveURLCoordinatorView.swift
//  UrlSaveCoordinator
//
//  Created by 김영균 on 6/29/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import CreateNewFolder
import SaveURL
import SelectFolder
import SwiftUI
import TCACoordinators

public struct SaveURLCoordinatorView: View {
    private let store: StoreOf<SaveURLCoordinator>

    public init(store: StoreOf<SaveURLCoordinator>) {
        self.store = store
    }

    public var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            switch screen.case {
            case let .createNewFolder(store):
                CreateNewFolderView(store: store)
                    .navigationBarHidden(true)

            case let .saveURL(store):
                SaveURLView(store: store)
                    .navigationBarHidden(true)

            case let .selectFolder(store):
                SelectFolderView(store: store)
                    .navigationBarHidden(true)
            }
        }
    }
}
