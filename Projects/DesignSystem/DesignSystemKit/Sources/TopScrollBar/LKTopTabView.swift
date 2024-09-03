//
//  LKTopTabView.swift
//  DesignSystemKit
//
//  Created by 안상희 on 6/29/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct LKTopTabView: View {
    private var icon: Image?
    private var isSelected: Bool
    private let title: String
    private let count: String?

    public init(
        icon: Image? = nil,
        isSelected: Bool,
        title: String,
        count: String? = nil
    ) {
        self.icon = icon
        self.isSelected = isSelected
        self.title = title
        self.count = count
    }

    public var body: some View {
        HStack(spacing: 4) {
            icon
                .frame(width: 24, height: 24)

            Text(title)
                .font(weight: .medium, semantic: .caption1)
                .foregroundStyle(
                    isSelected ? DesignSystemKitAsset.Colors.g1.swiftUIColor : DesignSystemKitAsset.Colors.g7.swiftUIColor
                )

            if let count {
                Text(count)
                    .font(weight: .medium, semantic: .caption1)
                    .foregroundStyle(
                        isSelected ? DesignSystemKitAsset.Colors.white.swiftUIColor : DesignSystemKitAsset.Colors.g6.swiftUIColor
                    )
            }
        }
        .frame(height: 24)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .frame(height: 36)
        .background(
            isSelected ? DesignSystemKitAsset.Colors.g8.swiftUIColor : DesignSystemKitAsset.Colors.g1.swiftUIColor
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
        count: "99+"
    )
}

public enum TopFolderType: Equatable {
    case custom
    case `default`
    case all
    case favorite

    public init?(string: String) {
        switch string.lowercased() {
        case "custom":
            self = .custom
        case "default":
            self = .default
        case "all":
            self = .all
        case "favorite":
            self = .favorite
        default:
            return nil
        }
    }
}
