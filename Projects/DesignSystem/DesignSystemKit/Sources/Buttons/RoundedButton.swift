//
//  RoundedButton.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/19/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct RoundedButton: View {
    private let title: String
    private let isDisabled: Bool
    private let action: () -> Void

    public init(title: String, isDisabled: Bool = false, action: @escaping () -> Void) {
        self.title = title
        self.isDisabled = isDisabled
        self.action = action
    }

    private enum Constant {
        static let horizontalPadding: CGFloat = 4
        static let verticalPadding: CGFloat = 14
        static let height: CGFloat = 48
        static let cornerRadius: CGFloat = 99.9
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.horizontal, Constant.horizontalPadding)
                .padding(.vertical, Constant.verticalPadding)
                .frame(maxWidth: .infinity, minHeight: Constant.height, maxHeight: Constant.height)
                .font(weight: .medium, semantic: .base2)
                .foregroundStyle(foregroundColor)
                .background(backgroundColor)
                .cornerRadius(Constant.cornerRadius, corners: .allCorners)
        }
        .buttonStyle(.plain)
        .disabled(isDisabled)
    }

    private var foregroundColor: Color {
        isDisabled ? DesignSystemKitAsset.Colors.g4.swiftUIColor : DesignSystemKitAsset.Colors.g1.swiftUIColor
    }

    private var backgroundColor: Color {
        isDisabled ? DesignSystemKitAsset.Colors.g2.swiftUIColor : DesignSystemKitAsset.Colors.g9.swiftUIColor
    }
}
