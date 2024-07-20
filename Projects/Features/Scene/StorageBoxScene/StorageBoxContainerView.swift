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
    @Perception.Bindable private var store: StoreOf<StorageBox>
    private let tabbar: () -> Content

    public init(
        store: StoreOf<StorageBox>,
        tabbar: @autoclosure @escaping () -> Content
    ) {
        self.store = store
        self.tabbar = tabbar
    }

    public var body: some View {
        WithPerceptionTracking {
            ZStack(alignment: .bottom) {
                StorageBoxView(store: store)
                tabbar()
            }
            .newFolderPopup(isPresented: $store.newFolderPopupIsPresented.projectedValue,
                            list: store.defaultFolders + store.customFolders, onComplete: { folderName in
                                store.send(.addNewFolder(folderName))
                            })
            .editFolderPopup(isPresented: $store.editFolderPopupIsPresented.projectedValue, onSelect: { index in
                if index == 0 {
                    store.send(.showRemoveFolderPopup, animation: .default)
                } else {
                    store.send(.tapChangeFolderName)
                }
            })
            .modal(isPresented: $store.removeFolderPopupIsPresented.projectedValue, content: {
                removeFolderPopup(onCancel: {
                    store.send(.cancelRemoveFolder, animation: .default)
                }, onRemove: {
                    store.send(.tapRemoveFolderButton)
                })
            })
            .toast(isPresented: $store.toastPopupIsPresented, type: .info, message: "폴더 이름을 변경했어요.", isEmbedTabbar: true)
            .navigationBarHidden(true)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
