//
//  SaveURLView.swift
//  SaveURLScene
//
//  Created by 김영균 on 6/29/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import LocalizationKit
import SwiftUI

public struct SaveURLView: View {
    @Perception.Bindable private var store: StoreOf<SaveURL>
    @FocusState private var isFocused: Bool

    public init(store: StoreOf<SaveURL>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 24) {
                LKTextMiddleTopBar(
                    title: LocalizationKitStrings.SaveURLScene.saveUrlViewNavigationTitle,
                    backButtonAction: { store.send(.backButtonTapped) },
                    action: {}
                )

                VStack(spacing: 0) { LKTextField(
                    text: $store.urlString.sending(\.textFieldChanged),
                    fieldText: LocalizationKitStrings.SaveURLScene.saveUrlViewUrlFieldTitle,
                    placeholder: LocalizationKitStrings.SaveURLScene.saveUrlViewUrlFieldPlaceholder,
                    helperText: LocalizationKitStrings.SaveURLScene.saveUrlViewUrlFieldHelperText,
                    isWarning: store.isTextFieldWarned
                )
                .focused($isFocused)
                .keyboardType(.URL)

                RoundedButton(
                    title: LocalizationKitStrings.SaveURLScene.saveUrlViewSaveButtonTitle,
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
            .clipboardToast(store: store.scope(state: \.clipboardToast, action: \.clipboardToast))
            .navigationBarHidden(true)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                isFocused = true
                store.send(.onAppear)
            }
        }
    }
}

extension View {
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
