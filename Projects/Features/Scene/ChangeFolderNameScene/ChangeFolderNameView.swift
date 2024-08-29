//
//  ChangeFolderNameView.swift
//  StorageBox
//
//  Created by 박소현 on 7/7/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import LocalizationKit
import SwiftUI

public struct ChangeFolderNameView: View {
    @Bindable private var store: StoreOf<ChangeFolderName>
    @FocusState private var isFocused: Bool

    public init(store: StoreOf<ChangeFolderName>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 24) {
            LKTextMiddleTopBar(
                title: LocalizationKitStrings.ChangeFolderNameScene.changeFolderNameViewNavigationTitle,
                backButtonAction: { store.send(.backButtonTapped) },
                action: {}
            )

            LKTextField(
                text: $store.newFolderName.sending(\.folderNameChanged),
                fieldText: LocalizationKitStrings.ChangeFolderNameScene.changeFolderNameViewTextFieldName,
                placeholder: LocalizationKitStrings.ChangeFolderNameScene.changeFolderNameViewTextFieldPlaceholder,
                helperText: LocalizationKitStrings.ChangeFolderNameScene.changeFolderNameViewTextFieldHelperText,
                textLimit: 15,
                isWarning: store.isTextFieldWarned
            )
            .focused($isFocused)

            RoundedButton(
                title: LocalizationKitStrings.ChangeFolderNameScene.changeFolderNameViewSaveButtonTitle,
                isDisabled: store.isSaveButtonDisabled,
                action: { store.send(.saveButtonTapped) }
            )
            .padding(20)

            Spacer()
        }
        .navigationBarHidden(true)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            isFocused = true
        }
    }
}
