//
//  ChangeFolderNameView.swift
//  StorageBox
//
//  Created by 박소현 on 7/7/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import SwiftUI

public struct ChangeFolderNameView: View {
    @Perception.Bindable private var store: StoreOf<ChangeFolderName>
    @FocusState private var isFocused: Bool

    public init(store: StoreOf<ChangeFolderName>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 24) {
                LKTextMiddleTopBar(
                    title: "폴더 이름 변경",
                    backButtonAction: { store.send(.backButtonTapped) },
                    action: {}
                )

                LKTextField(
                    text: $store.newFolderName.sending(\.folderNameChanged),
                    fieldText: "폴더명",
                    placeholder: "폴더명을 입력해주세요.",
                    helperText: "같은 이름의 폴더가 있어요",
                    textLimit: 15,
                    isWarning: store.isTextFieldWarned
                )
                .focused($isFocused)

                RoundedButton(
                    title: "저장",
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
}
