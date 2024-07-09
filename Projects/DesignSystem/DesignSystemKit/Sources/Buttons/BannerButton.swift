//
//  BannerButton.swift
//  DesignSystemKit
//
//  Created by 안상희 on 7/4/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct BannerButton: View {
    private let title: String
    private let action: () -> Void

    public init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 0) {
                Text(title)
                    .font(weight: .bold, semantic: .caption1)
                    .foregroundStyle(DesignSystemKitAsset.Colors.g7.swiftUIColor)

                Image(.icArrow)
                    .frame(width: 12, height: 12)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .frame(height: 38, alignment: .center)
            .background(DesignSystemKitAsset.Colors.gradient3)
            .cornerRadius(50, corners: .allCorners)
        }
    }
}

#Preview {
    BannerButton(title: "확인하기", action: {})
}
