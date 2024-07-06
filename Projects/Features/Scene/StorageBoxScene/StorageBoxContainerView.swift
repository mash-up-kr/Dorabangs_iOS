//
//  StorageBoxContainerView.swift
//  StorageBox
//
//  Created by 김영균 on 7/6/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct StorageBoxContainerView<Content: View>: View {
    private let store: StoreOf<StorageBox>
    private let tabbar: () -> Content

    public init(
        store: StoreOf<StorageBox>,
        tabbar: @autoclosure @escaping () -> Content
    ) {
        self.store = store
        self.tabbar = tabbar
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            StorageBoxView(store: store)
            tabbar()
        }
        .navigationBarHidden(true)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
