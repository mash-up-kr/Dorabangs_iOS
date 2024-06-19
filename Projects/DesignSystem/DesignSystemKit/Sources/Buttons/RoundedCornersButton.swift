//
//  RoundedCornersButton.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/19/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct RoundedCornersButton: View {
    private let title: String
    private let style: Style
    private let action: () -> Void
    
    public enum Style {
        case solidBlack
        case solidGray
    }
    
    public init(title: String, style: Style, action: @escaping () -> Void) {
        self.title = title
        self.style = style
        self.action = action
    }
    
    private enum Constant {
        static let horizontalPadding: CGFloat = 4
        static let verticalPadding: CGFloat = 14
        static let height: CGFloat = 48
        static let cornerRadius: CGFloat = 12
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .padding(.horizontal, Constant.horizontalPadding)
                .padding(.vertical, Constant.verticalPadding)
                .frame(maxWidth: .infinity, minHeight: Constant.height, maxHeight: Constant.height)
                .font(weight: .medium, semantic: .base2)
                .foregroundColor(foregroundColor)
                .background(backgroundColor)
                .cornerRadius(Constant.cornerRadius, corners: .allCorners)
        }
        .buttonStyle(.plain)
    }
    
    private var foregroundColor: Color {
        switch style {
        case .solidBlack: DesignSystemKitAsset.Colors.g1.swiftUIColor
        case .solidGray: DesignSystemKitAsset.Colors.g9.swiftUIColor
        }
    }
    
    private var backgroundColor: Color {
        switch style {
        case .solidBlack: DesignSystemKitAsset.Colors.g9.swiftUIColor
        case .solidGray: DesignSystemKitAsset.Colors.g1.swiftUIColor
        }
    }
}
