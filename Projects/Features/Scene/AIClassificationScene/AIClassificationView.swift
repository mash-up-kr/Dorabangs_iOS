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
        WithPerceptionTracking {
            GeometryReader { geometry in
                WithPerceptionTracking {
                    ZStack(alignment: .top) {
                        Group {
                            if let store = store.scope(state: \.cards, action: \.cards) {
                                AIClassificationCardView(store: store)
                                    .zIndex(1)
                            }
                        }
                        .applyIf(store.isLoading) { _ in
                            LoadingIndicator()
                                .frame(height: geometry.size.height)
                        }

                        VStack(spacing: 0) {
                            LKTextMiddleTopBar(
                                title: LocalizationKitStrings.AIClassificationScene.aiClassificationViewNavigationTitle,
                                backButtonAction: { store.send(.backButtonTapped) },
                                action: {}
                            )
                            .frame(height: Constant.LKTextMiddleTopBarHeight)

                            if let store = store.scope(state: \.tabs, action: \.tabs) {
                                AIClassificationTabView(store: store)
                                    .frame(height: Constant.AIClassificationTabViewHeight)
                                    .overlay {
                                        RoundedBottomBorder()
                                            .stroke(DesignSystemKitAsset.Colors.g1.swiftUIColor, lineWidth: 1)
                                    }
                            }
                        }
                        .zIndex(2)
                        .background(DesignSystemKitAsset.Colors.white.swiftUIColor.opacity(0.7))
                        .background(.ultraThinMaterial)
                        .shadow(color: DesignSystemKitAsset.Colors.primary.swiftUIColor.opacity(0.01), blur: 8, x: 0, y: -4)
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
}

// 상단 탭 뷰의 하단의 일직선
private struct RoundedBottomBorder: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        return path
    }
}
