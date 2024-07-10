//
//  AIClassificationCardSectionHeaderView.swift
//  AIClassification
//
//  Created by 김영균 on 7/9/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import SwiftUI

struct AIClassificationCardSectionHeaderView: View {
    let title: String
    let count: Int
    let action: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Text(title)
                .font(weight: .bold, semantic: .title)
                .foregroundStyle(DesignSystemKitAsset.Colors.g8.swiftUIColor)
                .frame(maxWidth: .infinity)

            Spacer().frame(height: 4)

            Text("분류한 링크\(count)개")
                .font(weight: .medium, semantic: .caption1)
                .foregroundStyle(DesignSystemKitAsset.Colors.g8.swiftUIColor)

            Spacer().frame(height: 20)

            Button(action: action) {
                Text("모두 이동")
                    .padding(.horizontal, 30)
                    .padding(.vertical, 8)
                    .font(weight: .medium, semantic: .caption3)
                    .foregroundStyle(DesignSystemKitAsset.Colors.white.swiftUIColor)
                    .background(DesignSystemKitAsset.Colors.g9.swiftUIColor)
                    .cornerRadius(99.9, corners: .allCorners)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 32)
        .background(DesignSystemKitAsset.Colors.gradient2)
    }
}
