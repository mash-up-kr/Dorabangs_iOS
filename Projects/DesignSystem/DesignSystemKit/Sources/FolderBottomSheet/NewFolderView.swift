//
//  NewFolderView.swift
//  DesignSystemKit
//
//  Created by 박소현 on 7/1/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct NewFolderView: View {
    public init() {}

    public var body: some View {
        HStack(spacing: 12) {
            DesignSystemKitAsset.Icons.icAddFolder
                .swiftUIImage
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(DesignSystemKitAsset.Colors.primary.swiftUIColor)
                .frame(width: 24, height: 24)

            Text("새 폴더 추가")
                .font(weight: .regular, semantic: .caption3)
                .foregroundStyle(DesignSystemKitAsset.Colors.primary.swiftUIColor)

            Spacer()
        }
        .frame(height: 52)
    }
}
