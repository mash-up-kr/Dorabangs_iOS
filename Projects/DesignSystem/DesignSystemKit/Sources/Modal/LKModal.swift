//
//  LKModal.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/21/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct LKModal: View {
    private let title: String
    private let content: String
    private let leftButtonTitle: String
    private let leftButtonAction: () -> Void
    private let rightButtonTitle: String
    private let rightButtonAction: () -> Void

    public init(
        title: String,
        content: String,
        leftButtonTitle: String,
        leftButtonAction: @escaping () -> Void,
        rightButtonTitle: String,
        rightButtonAction: @escaping () -> Void
    ) {
        self.title = title
        self.content = content
        self.leftButtonTitle = leftButtonTitle
        self.leftButtonAction = leftButtonAction
        self.rightButtonTitle = rightButtonTitle
        self.rightButtonAction = rightButtonAction
    }

    public var body: some View {
        VStack(spacing: 0) {
            Spacer().frame(height: 30)

            Text(title)
                .font(weight: .bold, semantic: .base1)
                .foregroundStyle(DesignSystemKitAsset.Colors.g8.swiftUIColor)
                .padding(.horizontal, 16)

            Spacer().frame(height: 8)

            Text(content)
                .multilineTextAlignment(.center)
                .frame(alignment: .center)
                .font(weight: .medium, semantic: .caption3)
                .foregroundStyle(DesignSystemKitAsset.Colors.g5.swiftUIColor)

            Spacer().frame(height: 30)

            HStack(spacing: 8) {
                RoundedCornersButton(title: leftButtonTitle, style: .solidGray, action: leftButtonAction)
                RoundedCornersButton(title: rightButtonTitle, style: .solidBlack, action: rightButtonAction)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .frame(width: 335)
        .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
        .cornerRadius(16, corners: .allCorners)
    }
}
