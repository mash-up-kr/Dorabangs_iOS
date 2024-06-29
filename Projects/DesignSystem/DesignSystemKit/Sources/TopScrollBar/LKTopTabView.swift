//
//  LKTopTabView.swift
//  DesignSystemKit
//
//  Created by 안상희 on 6/29/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct LKTopTabView: View {
    private var isSelected: Bool
    private let title: String
    private let count: String?
    private let action: () -> Void

    public init(
        isSelected: Bool,
        title: String,
        count: String?,
        action: @escaping () -> Void
    ) {
        self.isSelected = isSelected
        self.title = title
        self.count = count
        self.action = action
    }

    public var body: some View {
        HStack(spacing: 2) {
            Image(.icAll)
                .frame(width: 24, height: 24)

            Spacer()
                .frame(width: 2)

            Text(title)
                .font(weight: .medium, semantic: .caption1)
                .foregroundStyle(
                    isSelected ? DesignSystemKitAsset.Colors.white.swiftUIColor : DesignSystemKitAsset.Colors.g6.swiftUIColor
                )

            if let count = count {
                Text(count)
                    .font(weight: .medium, semantic: .caption1)
                    .foregroundStyle(
                        isSelected ? DesignSystemKitAsset.Colors.white.swiftUIColor : DesignSystemKitAsset.Colors.g6.swiftUIColor
                    )
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .background(
            isSelected ? DesignSystemKitAsset.Colors.g8.swiftUIColor : DesignSystemKitAsset.Colors.white.swiftUIColor
        )
        .border(
            isSelected ? DesignSystemKitAsset.Colors.g8.swiftUIColor : DesignSystemKitAsset.Colors.g2.swiftUIColor,
            cornerRadius: 20
        )
    }
}

#Preview {
    LKTopTabView(
        isSelected: true,
        title: "나중에 읽을 링크",
        count: "99+",
        action: {}
    )
}
