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
    @Bindable private var store: StoreOf<StorageBox>
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
        .editFolderPopup(isPresented: $store.editFolderPopupIsPresented.projectedValue, onSelect: { index in
            if index == 0 {
                store.send(.showRemoveFolderPopup)
            } else {
                store.send(.tapChangeFolderName)
            }
        })
        .modal(isPresented: $store.removeFolderPopupIsPresented.projectedValue, content: {
            removeFolderPopup(onCancel: {
                store.send(.cancelRemoveFolder)
            }, onRemove: {
                store.send(.tapRemoveFolderButton)
            })
        })
        .toast(isPresented: $store.toastPopupIsPresented, type: .info, message: store.toastMessage, isEmbedTabbar: true)
        .navigationBarHidden(true)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
