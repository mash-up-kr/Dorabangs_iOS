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
        VStack {
            HStack(alignment: .center, spacing: 4) {
                DesignSystemKitAsset.Icons.icStarMedium
                    .swiftUIImage.resizable()
                    .frame(width: 20, height: 20)

                Text(title)
                    .font(weight: .bold, semantic: .title)
                    .foregroundStyle(DesignSystemKitAsset.Colors.g8.swiftUIColor)
            }
            .frame(maxWidth: .infinity)

            Spacer().frame(height: 4)

            Text(LocalizationKitStrings.AIClassificationScene.classifiedLinksCount(count))
                .font(weight: .medium, semantic: .caption1)
                .foregroundStyle(DesignSystemKitAsset.Colors.g8.swiftUIColor)

            Spacer().frame(height: 12)

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
        .padding(.vertical, 48)
        .background(DesignSystemKitAsset.Colors.g1.swiftUIColor)
    }
}
