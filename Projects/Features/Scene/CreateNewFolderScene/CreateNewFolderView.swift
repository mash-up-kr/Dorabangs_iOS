//
//  CreateNewFolderView.swift
//  CreateNewFolder
//
//  Created by 김영균 on 7/3/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import LocalizationKit
import SwiftUI

public struct CreateNewFolderView: View {
    @Bindable private var store: StoreOf<CreateNewFolder>
    @FocusState private var isFocused: Bool

    public init(store: StoreOf<CreateNewFolder>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 24) {
            LKTextMiddleTopBar(
                title: LocalizationKitStrings.CreateNewFolderScene.createNewFolderViewNavigationTitle,
                backButtonAction: { store.send(.backButtonTapped) },
                action: {}
            )
            VStack(spacing: 0) {
                LKTextField(
                    text: $store.newFolderName.sending(\.folderNameChanged),
                    fieldText: LocalizationKitStrings.CreateNewFolderScene.createNewFolderViewTextFieldName,
                    placeholder: LocalizationKitStrings.CreateNewFolderScene.createNewFolderViewTextFieldPlaceholder,
                    helperText: LocalizationKitStrings.CreateNewFolderScene.createNewFolderViewTextFieldHelperText,
                    textLimit: 15,
                    isWarning: store.isTextFieldWarned
                )
                .focused($isFocused)

                RoundedButton(
                    title: LocalizationKitStrings.CreateNewFolderScene.createNewFolderViewSaveButtonTitle,
                    isDisabled: store.isSaveButtonDisabled,
                    action: { store.send(.saveButtonTapped) }
                )
                .padding(20)

                Spacer()
            }
            .applyIf(store.isLoading, apply: { view in
                view
                    .disabled(store.isLoading)
                    .overlay(LoadingIndicator())
            })
        }
        .navigationBarHidden(true)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isFocused = true
        }
    }
}
