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
import LocalizationKit
import StorageBoxCoordinator
import SwiftUI

public struct TabCoordinatorView: View {
    @Bindable private var store: StoreOf<TabCoordinator>
    @Environment(\.scenePhase) private var scenePhase

    public init(store: StoreOf<TabCoordinator>) {
        self.store = store
    }

    public var body: some View {
        TabView(selection: $store.selectedTab.sending(\.tabSelected)) {
            HomeCoordinatorView(store: store.scope(state: \.home, action: \.home), tabbar: tabbar)
                .tag(TabCoordinator.Tab.home)
                .navigationBarHidden(true)
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)

            StorageBoxCoordinatorView(store: store.scope(state: \.storageBox, action: \.storageBox), tabbar: tabbar)
                .tag(TabCoordinator.Tab.storageBox)
                .navigationBarHidden(true)
                .navigationTitle("")
                .navigationBarTitleDisplayMode(.inline)
        }
        .clipboardToast(store: store.scope(state: \.clipboardToast, action: \.clipboardToast))
        .onAppear {
            UITabBar.appearance().isHidden = true
            checkClipboardURL()
        }
        .onChange(of: scenePhase) { _, newValue in
            guard newValue == .active else { return }
            checkClipboardURL()
        }
    }

    private var tabbar: some View {
        LKTabBar(
            selection: $store.selectedTab.sending(\.tabSelected),
            tabItems: [
                LKTabBarItem(
                    tag: TabCoordinator.Tab.home,
                    title: LocalizationKitStrings.Common.home,
                    image: DesignSystemKitAsset.Icons.icHomeDefault.swiftUIImage,
                    selectedImage: DesignSystemKitAsset.Icons.icHomeActive.swiftUIImage
                ),
                LKTabBarItem(
                    tag: TabCoordinator.Tab.storageBox,
                    title: LocalizationKitStrings.Common.storage,
                    image: DesignSystemKitAsset.Icons.icFolderDefault.swiftUIImage,
                    selectedImage: DesignSystemKitAsset.Icons.icFolderActive.swiftUIImage
                )
            ]
        )
    }

    private func checkClipboardURL() {
        if let url = UIPasteboard.general.url {
            store.send(.clipboardURLChanged(url))
            UIPasteboard.general.url = nil
        }
    }
}

extension View {
    @ViewBuilder
    func clipboardToast(store: StoreOf<ClipboardToastFeature>) -> some View {
        @Bindable var store = store
        clipboardToast(
            isPresented: $store.isPresented.sending(\.isPresentedChanged),
            urlString: store.shared.urlString,
            saveAction: { store.send(.saveButtonTapped) },
            closeAction: { store.send(.closeButtonTapped) }
        )
    }
}
