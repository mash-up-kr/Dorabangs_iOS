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
    let onSelect: (String, FolderType) -> Void
    let onEdit: (String, FolderType) -> Void
    let moreIcon: Image

    public init(
        storageBoxList: [Folder],
        onSelect: @escaping (String, FolderType) -> Void,
        onEdit: @escaping (String, FolderType) -> Void,
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
                    LKDivider()
                        .padding(.horizontal, 12)
                }
                StorageBoxItem(
                    model: storageBoxList[index],
                    onMove: { onSelect(storageBoxList[index].id, storageBoxList[index].type) },
                    onEdit: { onEdit(storageBoxList[index].id, storageBoxList[index].type) },
                    moreIcon: moreIcon
                )
            }
        }
        .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
        .cornerRadius(12, corners: .allCorners)
        .padding(.horizontal, 20)
    }
}
