//
//  CreateNewFolderView.swift
//  CreateNewFolder
//
//  Created by 김영균 on 7/3/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import SwiftUI

public struct CreateNewFolderView: View {
    @Perception.Bindable private var store: StoreOf<CreateNewFolder>
    @FocusState private var isFocused: Bool

    public init(store: StoreOf<CreateNewFolder>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 24) {
                LKTextMiddleTopBar(
                    title: "새 폴더 추가",
                    backButtonAction: { store.send(.backButtonTapped) },
                    action: {}
                )
                VStack(spacing: 0) {
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
}
