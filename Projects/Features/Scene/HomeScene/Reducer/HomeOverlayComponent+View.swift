//
//  HomeOverlayComponent+View.swift
//  Home
//
//  Created by 김영균 on 7/10/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import SwiftUI

extension View {
    @ViewBuilder
    func cardActionSheet(store: StoreOf<HomeOverlayComponent>) -> some View {
        @Perception.Bindable var store = store
        actionSheet(
            isPresented: $store.isCardActionSheetPresented.projectedValue,
            items: [
                LKActionItem(
                    title: "링크 삭제",
                    image: DesignSystemKitAsset.Icons.icDelete.swiftUIImage,
                    style: .destructive,
                    action: {
                        store.send(.set(\.isCardActionSheetPresented, false))
                        store.send(.set(\.isDeleteCardModalPresented, true))
                    }
                ),
                LKActionItem(
                    title: "폴더 이동",
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
                    title: "링크 삭제",
                    content: "한 번 삭제한 링크는 다시 복구할 수 없어요.\n그래도 삭제하시겠어요?",
                    leftButtonTitle: "취소",
                    leftButtonAction: {
                        store.send(.set(\.isDeleteCardModalPresented, false))
                        store.send(.set(\.isCardActionSheetPresented, true))
                    },
                    rightButtonTitle: "삭제",
                    rightButtonAction: {
                        store.send(.set(\.isDeleteCardModalPresented, false))
                        store.send(.presentToast(toastMessage: "삭제 완료했어요."))
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
            folders: store.folders,
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

    @ViewBuilder
    func clipboardToast(store: StoreOf<ClipboardToastFeature>) -> some View {
        @Perception.Bindable var store = store
        clipboardToast(
            isPresented: $store.isPresented.sending(\.isPresentedChanged),
            urlString: store.shared.urlString,
            saveAction: { store.send(.saveButtonTapped) },
            closeAction: { store.send(.closeButtonTapped) }
        )
    }
}
