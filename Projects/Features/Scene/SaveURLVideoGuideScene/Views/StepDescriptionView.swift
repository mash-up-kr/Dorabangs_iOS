//
//  StepDescriptionView.swift
//  SaveURLVideoGuide
//
//  Created by 김영균 on 7/24/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import SwiftUI

struct StepDescriptionView: View {
    var step: Int
    var description: String

    var body: some View {
        HStack(spacing: 6) {
            Text("\(step)")
                .frame(width: 20, height: 20)
                .font(weight: .medium, semantic: .caption2)
                .foregroundStyle(DesignSystemKitAsset.Colors.g7.swiftUIColor)
                .background(
                    Rectangle()
                        .fill(DesignSystemKitAsset.Colors.g2.swiftUIColor)
                        .frame(width: 20, height: 20)
                )

            Text(description)
                .font(weight: .medium, semantic: .caption3)
                .foregroundStyle(DesignSystemKitAsset.Colors.g7.swiftUIColor)
        }
    }
}
