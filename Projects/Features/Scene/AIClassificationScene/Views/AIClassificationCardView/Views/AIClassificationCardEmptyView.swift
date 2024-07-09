//
//  AIClassificationCardEmptyView.swift
//  AIClassification
//
//  Created by 김영균 on 7/8/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import SwiftUI

struct AIClassificationCardEmptyView: View {
    let title: String
    let action: () -> Void

    enum Constant {
        static let LKTextMiddleTopBarHeight: CGFloat = 48
        static let AIClassificationTabViewHeight: CGFloat = 56
    }

    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                Spacer().frame(height: Constant.LKTextMiddleTopBarHeight + Constant.AIClassificationTabViewHeight + 77)

                DesignSystemKitAsset.Images.sample
                    .swiftUIImage
                    .resizable()
                    .scaledToFit()
                    .frame(width: 252, height: 252)

                Text("분류한 링크를 모두 확인했어요!")
                    .font(weight: .medium, semantic: .base1)
                    .multilineTextAlignment(.center)
                    .foregroundColor(DesignSystemKitAsset.Colors.g7.swiftUIColor)

                Spacer()
                    .frame(height: 16)

                Button(action: action) {
                    Text(title)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 8)
                        .frame(height: 38)
                        .font(weight: .medium, semantic: .caption1)
                        .foregroundStyle(DesignSystemKitAsset.Colors.white.swiftUIColor)
                        .background(DesignSystemKitAsset.Colors.g9.swiftUIColor)
                        .cornerRadius(99.9, corners: .allCorners)
                }
                .buttonStyle(.plain)
                .frame(height: 38)

                Spacer()
            }
        }
    }
}
