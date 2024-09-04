//
//  AIClassificationView.swift
//  AIClassification
//
//  Created by 김영균 on 7/7/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import LocalizationKit
import SwiftUI

public struct AIClassificationView: View {
    private let store: StoreOf<AIClassification>

    public init(store: StoreOf<AIClassification>) {
        self.store = store
    }

    private enum Constant {
        static let LKTextMiddleTopBarHeight: CGFloat = 48
        static let AIClassificationTabViewHeight: CGFloat = 56
    }

    public var body: some View {
        GeometryReader { _ in
            VStack(spacing: 0) {
                LKTextMiddleTopBar(
                    title: LocalizationKitStrings.AIClassificationScene.aiClassificationViewNavigationTitle,
                    backButtonAction: { store.send(.backButtonTapped) }
                )
                .frame(height: Constant.LKTextMiddleTopBarHeight)

                if let store = store.scope(state: \.tabs, action: \.tabs) {
                    AIClassificationTabView(store: store)
                        .frame(height: Constant.AIClassificationTabViewHeight)
                        .dividerLine(edge: .bottom)
                }

                Group {
                    if let store = store.scope(state: \.cards, action: \.cards) {
                        AIClassificationCardView(store: store)
                    }
                }
                .applyIf(store.isLoading) { _ in
                    LoadingIndicator()
                }
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
        .navigationBarHidden(true)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
