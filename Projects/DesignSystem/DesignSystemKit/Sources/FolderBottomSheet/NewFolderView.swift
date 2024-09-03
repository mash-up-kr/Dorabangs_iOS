//
//  NewFolderView.swift
//  DesignSystemKit
//
//  Created by 박소현 on 7/1/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import LocalizationKit
import SwiftUI

public struct NewFolderView: View {
    public init() {}

    public var body: some View {
        HStack(spacing: 12) {
            DesignSystemKitAsset.Icons.icAddFolder
                .swiftUIImage
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(DesignSystemKitAsset.Colors.primary500.swiftUIColor)
                .frame(width: 24, height: 24)

            Text(LocalizationKitStrings.DesignsSystemKit.addNewFolder)
                .font(weight: .regular, semantic: .caption3)
                .foregroundStyle(DesignSystemKitAsset.Colors.primary500.swiftUIColor)

            Spacer()
        }
        .frame(height: 52)
    }
}
