//
//  LKTextMiddleTopBar.swift
//  DesignSystemKit
//
//  Created by 안상희 on 6/27/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct LKTextMiddleTopBar: View {
    private let title: String?
    private let backButtonAction: () -> Void
    private let rightButtonEnabled: Bool?
    private let rightButtonImage: Image?
    private let action: () -> Void

    public init(
        title: String? = nil,
        backButtonAction: @escaping () -> Void = {},
        rightButtonImage: Image? = nil,
        rightButtonEnabled: Bool? = false,
        action: @escaping () -> Void = {}
    ) {
        self.title = title
        self.rightButtonEnabled = rightButtonEnabled
        self.rightButtonImage = rightButtonImage
        self.backButtonAction = backButtonAction
        self.action = action
    }

    public var body: some View {
        HStack(spacing: 8) {
            Image(.icChevronLeftBig)
                .frame(width: 24, height: 24)
                .onTapGesture(perform: backButtonAction)

            Spacer()

            if let rightButtonEnabled, rightButtonEnabled {
                Button(action: {
                    action()
                }) {
                    rightButtonImage?
                        .renderingMode(.template)
                        .foregroundColor(DesignSystemKitAsset.Colors.g9.swiftUIColor)
                }
                .frame(width: 24, height: 24)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .frame(height: 48)
        .overlay {
            if let title {
                Text(title)
                    .font(weight: .bold, semantic: .base1)
                    .foregroundStyle(DesignSystemKitAsset.Colors.g9.swiftUIColor)
            }
        }
    }
}
