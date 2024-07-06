//
//  EditFolderPopupModifier.swift
//  StorageBox
//
//  Created by 박소현 on 7/7/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI
import Models
import DesignSystemKit

public struct EditFolderPopupModifier: ViewModifier {
    @Binding var isPresented: Bool
    let onSelect: (Int) -> Void
    
    public init(isPresented: Binding<Bool>,
                onSelect: @escaping (Int) -> Void
    ) {
        _isPresented = isPresented
        self.onSelect = onSelect
    }
    
    public func body(content: Content) -> some View {
        content
            .actionSheet(isPresented: $isPresented, items: [.init(title: "폴더 삭제", image: DesignSystemKitAsset.Icons.icDelete.swiftUIImage.resizable(), action: {
                onSelect(0)
            }), .init(title: "폴더 이름 변경", image: DesignSystemKitAsset.Icons.icNameEdit.swiftUIImage.resizable(), action: {
                onSelect(1)
            })])
    }
}
