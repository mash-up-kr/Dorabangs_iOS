//
//  OnboardingView.swift
//  Onboarding
//
//  Created by 김영균 on 7/6/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import SwiftUI

public struct OnboardingView: View {
    private let store: StoreOf<Onboarding>

    public init(store: StoreOf<Onboarding>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                Spacer().frame(height: 53)

                Text("주로 어떤 링크를 저장하시나요?")
                    .font(weight: .extrabold, semantic: .subtitle1)
                    .foregroundStyle(DesignSystemKitAsset.Colors.g9.swiftUIColor)

                Spacer().frame(height: 8)

                Text("1개 이상 선택해주세요")
                    .font(weight: .regular, semantic: .caption3)
                    .foregroundStyle(DesignSystemKitAsset.Colors.g5.swiftUIColor)

                Spacer().frame(height: 53)

                FlowLayoutView(items: store.keywords) { keyword in
                    KeywordView(title: keyword) {
                        store.send(.keywordSelected(keyword: keyword))
                    }
                }
                .padding(.horizontal, 24)

                RoundedButton(title: "완료", isDisabled: store.isCompleteButtonDisabled) {
                    store.send(.completeButtonTapped)
                }
                .padding(20)
            }
            .navigationBarHidden(true)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                store.send(.onAppear)
            }
        }
    }
}
