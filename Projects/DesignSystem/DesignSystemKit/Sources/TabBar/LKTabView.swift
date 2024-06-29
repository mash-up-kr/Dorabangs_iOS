//
//  LKTabView.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/24/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct LKTabView<SelectionValue, Content>: View where SelectionValue: Hashable, Content: View {
    @Binding private var selection: SelectionValue
    private let content: () -> Content
    private let tabItems: [LKTabBarItem<SelectionValue>]

    public init(
        selection: Binding<SelectionValue>,
        @ViewBuilder content: @escaping () -> Content,
        tabItems: [LKTabBarItem<SelectionValue>]
    ) {
        _selection = selection
        self.content = content
        self.tabItems = tabItems
    }

    public var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selection, content: content)
            LKTabBar(selection: $selection, tabItems: tabItems)
        }
        .onAppear {
            UITabBar.appearance().isHidden = true
        }
    }
}
