//
//  LKToast.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/24/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct LKToast: View {
    public enum ToastType {
        case info, warning
    }

    private let type: ToastType
    private let message: String

    private var image: Image {
        switch type {
        case .info:
            DesignSystemKitAsset.Icons.icCheckmark.swiftUIImage
        case .warning:
            DesignSystemKitAsset.Icons.icCircleAlert.swiftUIImage
        }
    }

    public init(type: ToastType, message: String) {
        self.type = type
        self.message = message
    }

    public var body: some View {
        HStack(spacing: 8) {
            image
                .resizable()
                .frame(width: 24, height: 24)

            Text(message)
                .lineLimit(1)
                .font(weight: .regular, semantic: .caption2)
                .foregroundStyle(DesignSystemKitAsset.Colors.g2.swiftUIColor)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .background(DesignSystemKitAsset.Colors.dimmed80.swiftUIColor)
        .cornerRadius(999, corners: .allCorners)
        .padding(.horizontal, 30)
    }
}

#Preview {
    LKToast(type: .warning, message: "Hello, World!")
}
