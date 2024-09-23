//
//  WebViewCoordinatorView.swift
//  WebViewCoordinator
//
//  Created by 김영균 on 9/23/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import AISummary
import ComposableArchitecture
import SwiftUI
import TCACoordinators
import Web

public struct WebViewCoordinatorView: View {
    private let store: StoreOf<WebViewCoordinator>

    public init(store: StoreOf<WebViewCoordinator>) {
        self.store = store
    }

    public var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            switch screen.case {
            case let .web(store):
                WebView(store: store)
                    .navigationBarHidden(true)
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)

            case let .aiSummary(store):
                AISummaryView(store: store)
                    .navigationBarHidden(true)
                    .navigationTitle("")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
