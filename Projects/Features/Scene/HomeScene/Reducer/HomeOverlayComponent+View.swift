//
//  HomeOverlayComponent+View.swift
//  Home
//
//  Created by 김영균 on 7/10/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import LocalizationKit
import SwiftUI

extension View {
    @ViewBuilder
    func cardActionSheet(store: StoreOf<HomeOverlayComponent>) -> some View {
        @Perception.Bindable var store = store
        actionSheet(
            isPresented: $store.isCardActionSheetPresented.projectedValue,
            items: [
                LKActionItem(
                    title: LocalizationKitStrings.HomeScene.deletePostActionSheetItemTitle,
                    image: DesignSystemKitAsset.Icons.icDelete.swiftUIImage,
                    style: .destructive,
                    action: {
                        store.send(.set(\.isCardActionSheetPresented, false))
                        store.send(.set(\.isDeleteCardModalPresented, true))
                    }
                ),
                LKActionItem(
                    title: LocalizationKitStrings.HomeScene.movePostActionSheetItemTitle,
                    image: DesignSystemKitAsset.Icons.icNameEdit.swiftUIImage,
                    style: .default,
                    action: {
                        store.send(.set(\.isCardActionSheetPresented, false))
                        store.send(.set(\.isSelectFolderBottomSheetPresented, true))
                    }
                )
            ]
        )
    }

    @ViewBuilder
    func deleteCardModal(store: StoreOf<HomeOverlayComponent>) -> some View {
        @Perception.Bindable var store = store
        modal(
            isPresented: $store.isDeleteCardModalPresented.projectedValue,
            content: {
                LKModal(
                    title: LocalizationKitStrings.HomeScene.deleteCardModalTitle,
                    content: LocalizationKitStrings.HomeScene.deleteCardModalDescription,
                    leftButtonTitle: LocalizationKitStrings.HomeScene.deleteCardModalLeftButtonTitle,
                    leftButtonAction: {
                        store.send(.set(\.isDeleteCardModalPresented, false))
                        store.send(.set(\.isCardActionSheetPresented, true))
                    },
                    rightButtonTitle: LocalizationKitStrings.HomeScene.deleteCardModalRightButtonTitle,
                    rightButtonAction: {
                        store.send(.deleteButtonTapped)
                        store.send(.set(\.isDeleteCardModalPresented, false))
                    }
                )
            }
        )
    }

    @ViewBuilder
    func selectFolderBottomSheet(store: StoreOf<HomeOverlayComponent>) -> some View {
        @Perception.Bindable var store = store
        bottomSheet(
            isPresented: $store.isSelectFolderBottomSheetPresented.projectedValue,
            folders: Array(store.folderList.values),
            onSelectNewFolder: {
                store.send(.set(\.isSelectFolderBottomSheetPresented, false))
                store.send(.createNewFolderButtonTapped)
            },
            onComplete: { store.send(.selectFolderCompleted(folder: $0)) }
        )
    }

    @ViewBuilder
    func toast(store: StoreOf<HomeOverlayComponent>) -> some View {
        @Perception.Bindable var store = store
        toast(
            isPresented: $store.isToastPresented.projectedValue,
            type: .info,
            message: store.toastMessage,
            isEmbedTabbar: true
        )
    }
}
