//
//  StorageBoxSection.swift
//  StorageBox
//
//  Created by 박소현 on 7/7/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import Models
import SwiftUI

public struct StorageBoxSection: View {
    let storageBoxList: [Folder]
    let onSelect: (Int) -> Void
    let onEdit: (Int) -> Void
    let moreIcon: Image

    public init(
        storageBoxList: [Folder],
        onSelect: @escaping (Int) -> Void,
        onEdit: @escaping (Int) -> Void,
        moreIcon: Image
    ) {
        self.storageBoxList = storageBoxList
        self.onSelect = onSelect
        self.onEdit = onEdit
        self.moreIcon = moreIcon
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(storageBoxList.indices, id: \.self) { index in
                if index > 0 {
                    Divider()
                        .frame(height: 1)
                        .padding(.horizontal, 12)
                        .foregroundColor(DesignSystemKitAsset.Colors.g1.swiftUIColor)
                }
                StorageBoxItem(
                    model: storageBoxList[index],
                    onMove: { onSelect(index) },
                    onEdit: { onEdit(index) },
                    moreIcon: moreIcon
                )
            }
        }
        .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
        .cornerRadius(12, corners: .allCorners)
        .padding(.horizontal, 20)
    }
}
