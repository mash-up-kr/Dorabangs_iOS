//
//  EditFolderPopupModifier.swift
//  StorageBox
//
//  Created by 박소현 on 7/7/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import LocalizationKit
import Models
import SwiftUI

public struct EditFolderPopupModifier: ViewModifier {
    @Binding var isPresented: Bool
    let onSelect: (Int) -> Void

    public init(isPresented: Binding<Bool>,
                onSelect: @escaping (Int) -> Void)
    {
        _isPresented = isPresented
        self.onSelect = onSelect
    }

    public func body(content: Content) -> some View {
        content
            .actionSheet(
                isPresented: $isPresented,
                items: [
                    .init(
                        title: LocalizationKitStrings.StorageBoxScene.deleteFolderActionSheetItemTitle,
                        image: DesignSystemKitAsset.Icons.icDelete.swiftUIImage.resizable(),
                        style: .destructive,
                        action: { onSelect(0) }
                    ),
                    .init(
                        title: LocalizationKitStrings.StorageBoxScene.renameFolderActionSheetItemTitle,
                        image: DesignSystemKitAsset.Icons.icNameEdit.swiftUIImage.resizable(),
                        action: { onSelect(1) }
                    )
                ]
            )
    }
}
