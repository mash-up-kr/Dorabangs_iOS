//
//  TabCoordinatorView.swift
//  TabCoordinator
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import HomeCoordinator
import StorageBoxCoordinator
import SwiftUI

public struct TabCoordinatorView: View {
    @Perception.Bindable private var store: StoreOf<TabCoordinator>

    public init(store: StoreOf<TabCoordinator>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            TabView(selection: $store.selectedTab.sending(\.tabSelected)) {
                HomeCoordinatorView(store: store.scope(state: \.home, action: \.home), tabbar: tabbar)
                    .tag(TabCoordinator.Tab.home)
                    .navigationBarHidden(true)

                StorageBoxCoordinatorView(store: store.scope(state: \.storageBox, action: \.storageBox), tabbar: tabbar)
                    .tag(TabCoordinator.Tab.storageBox)
                    .navigationBarHidden(true)
            }
            .onAppear {
                UITabBar.appearance().isHidden = true
            }
        }
    }

    private var tabbar: some View {
        LKTabBar(
            selection: $store.selectedTab.sending(\.tabSelected),
            tabItems: [
                LKTabBarItem(
                    tag: TabCoordinator.Tab.home,
                    title: "홈",
                    image: DesignSystemKitAsset.Icons.icHome.swiftUIImage,
                    selectedImage: DesignSystemKitAsset.Icons.icHomeFilled.swiftUIImage
                ),
                LKTabBarItem(
                    tag: TabCoordinator.Tab.storageBox,
                    title: "보관함",
                    image: DesignSystemKitAsset.Icons.icFolder.swiftUIImage,
                    selectedImage: DesignSystemKitAsset.Icons.icFloderFilled.swiftUIImage
                )
            ]
        )
    }
}
