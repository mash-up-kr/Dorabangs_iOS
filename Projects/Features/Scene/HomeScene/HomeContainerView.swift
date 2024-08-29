//
//  HomeContainerView.swift
//  Home
//
//  Created by 김영균 on 7/6/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import SwiftUI

public struct HomeContainerView<Content: View>: View {
    private let store: StoreOf<Home>
    private let overlayComponent: StoreOf<HomeOverlayComponent>
    private let tabbar: () -> Content

    public init(
        store: StoreOf<Home>,
        tabbar: @autoclosure @escaping () -> Content
    ) {
        self.store = store
        overlayComponent = store.scope(state: \.overlayComponent, action: \.overlayComponent)
        self.tabbar = tabbar
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            HomeView(store: store)
            tabbar()
        }
        .cardActionSheet(store: overlayComponent)
        .deleteCardModal(store: overlayComponent)
        .selectFolderBottomSheet(store: overlayComponent)
        .toast(store: overlayComponent)
        .navigationBarHidden(true)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
