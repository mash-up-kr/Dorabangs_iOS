//
//  SaveURLView.swift
//  SaveURLScene
//
//  Created by 김영균 on 6/29/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import SwiftUI

public struct SaveURLView: View {
    @Perception.Bindable private var store: StoreOf<SaveURL>

    public init(store: StoreOf<SaveURL>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 24) {
                LKTextMiddleTopBar(
                    title: "링크 저장",
                    backButtonAction: { store.send(.backButtonTapped) },
                    action: {}
                )

                LKTextField(
                    text: $store.urlString.sending(\.urlStringChanged),
                    fieldText: "링크",
                    placeholder: "URL을 입력해주세요",
                    helperText: "유효한 링크를 입력해주세요.",
                    isWarning: store.isTextFieldWarned
                )

                RoundedButton(
                    title: "저장",
                    isDisabled: store.isSaveButtonDisabled,
                    action: { store.send(.saveButtonTapped) }
                )
                .padding(20)

                Spacer()
            }
            .navigationBarHidden(true)
        }
    }
}
