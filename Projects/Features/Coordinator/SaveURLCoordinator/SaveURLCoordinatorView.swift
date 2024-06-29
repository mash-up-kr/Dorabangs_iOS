//
//  SaveURLCoordinatorView.swift
//  UrlSaveCoordinator
//
//  Created by 김영균 on 6/29/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import SaveURL
import SwiftUI
import TCACoordinators

public struct SaveURLCoordinatorView: View {
    private let store: StoreOf<SaveURLCoordinator>

    public init(store: StoreOf<SaveURLCoordinator>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
                switch screen.case {
                case let .saveURL(store):
                    SaveURLView(store: store)
                }
            }
        }
    }
}
