//
//  TabCoordinatorView.swift
//  TabCoordinator
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import FolderCoordinator
import HomeCoordinator
import SwiftUI

public struct TabCoordinatorView: View {
    @Bindable private var store: StoreOf<TabCoordinator>

    public init(store: StoreOf<TabCoordinator>) {
        self.store = store
    }

    public var body: some View {
        LKTabView(
            selection: $store.selectedTab.sending(\.tabSelected),
            content: {
                HomeCoordinatorView(store: store.scope(state: \.home, action: \.home))
                    .tag(TabCoordinator.Tab.home)

                FolderCoordinatorView(store: store.scope(state: \.folder, action: \.folder))
                    .tag(TabCoordinator.Tab.folder)
            },
            tabItems: [
                LKTabBarItem(
                    tag: .home,
                    title: "홈",
                    image: DesignSystemKitAsset.Icons.icHome.swiftUIImage,
                    selectedImage: DesignSystemKitAsset.Icons.icHomeFilled.swiftUIImage
                ),
                LKTabBarItem(
                    tag: .folder,
                    title: "보관함",
                    image: DesignSystemKitAsset.Icons.icFloder.swiftUIImage,
                    selectedImage: DesignSystemKitAsset.Icons.icFloderFilled.swiftUIImage
                )
            ]
        )
    }
}
