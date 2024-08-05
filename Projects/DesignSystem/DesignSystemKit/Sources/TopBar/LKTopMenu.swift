//
//  LKTopMenu.swift
//  DesignSystemKit
//
//  Created by 안상희 on 6/27/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct LKTopMenu: View {
    private let title: String
    private let action: () -> Void

    public init(
        title: String,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.action = action
    }

    public var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(weight: .medium, semantic: .caption2)
                .foregroundStyle(DesignSystemKitAsset.Colors.g9.swiftUIColor)

            Text(".")
                .frame(width: 3, height: 3)
        }
        .frame(height: 48)
    }
}
