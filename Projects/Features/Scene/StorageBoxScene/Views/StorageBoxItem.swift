//
//  StorageBoxItem.swift
//  StorageBox
//
//  Created by 박소현 on 7/7/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import Models
import SwiftUI

public struct StorageBoxItem: View {
    let model: StorageBoxModel
    let onMove: () -> Void
    let onEdit: () -> Void
    let moreIcon: Image

    public init(model: StorageBoxModel,
                onMove: @escaping () -> Void,
                onEdit: @escaping () -> Void,
                moreIcon: Image)
    {
        self.model = model
        self.onMove = onMove
        self.onEdit = onEdit
        self.moreIcon = moreIcon
    }

    public var body: some View {
        HStack {
            DesignSystemKitAsset.Icons.icFolder.swiftUIImage
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.leading, 12)

            Text(model.title)
                .font(weight: .medium, semantic: .caption3)
                .foregroundStyle(DesignSystemKitAsset.Colors.g9.swiftUIColor)
                .onTapGesture {
                    onMove()
                }

            Spacer()

            Text("\(model.count)")
                .font(weight: .medium, semantic: .caption3)
                .foregroundStyle(DesignSystemKitAsset.Colors.g4.swiftUIColor)

            moreIcon
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.black)
                .frame(width: 24, height: 24)
                .padding(.trailing, 12)
                .onTapGesture {
                    onEdit()
                }
        }
        .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
        .frame(height: 52)
    }
}
