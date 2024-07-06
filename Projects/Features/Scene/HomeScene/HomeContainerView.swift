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
    private let tabbar: () -> Content

    public init(
        store: StoreOf<Home>,
        tabbar: @autoclosure @escaping () -> Content
    ) {
        self.store = store
        self.tabbar = tabbar
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            HomeView(store: store)
            tabbar()
        }
        .navigationBarHidden(true)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
