//
//  AIClassificationCardSectionHeaderView.swift
//  AIClassification
//
//  Created by 김영균 on 7/9/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import LocalizationKit
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

            Text(LocalizationKitStrings.AIClassificationScene.classifiedLinksCount(count))
                .font(weight: .medium, semantic: .caption1)
                .foregroundStyle(DesignSystemKitAsset.Colors.g8.swiftUIColor)

            Spacer().frame(height: 20)

            Button(action: action) {
                Text(LocalizationKitStrings.AIClassificationScene.moveAllButtonTitle)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .frame(height: 36, alignment: .center)
                    .font(weight: .medium, semantic: .caption2)
                    .foregroundStyle(DesignSystemKitAsset.Colors.g1.swiftUIColor)
                    .background(DesignSystemKitAsset.Colors.g8.swiftUIColor)
                    .cornerRadius(99.9, corners: .allCorners)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 32)
        .background(DesignSystemKitAsset.Colors.gradient2)
    }
}
