//
//  NewFolderPopupModifier.swift
//  StorageBox
//
//  Created by 박소현 on 7/7/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import Models
import SwiftUI

public struct NewFolderPopupModifier: ViewModifier {
    @Binding var isPresented: Bool
    @State var newFolderName: String = ""
    let duplicatedCheckList: [StorageBoxModel]
    let onComplete: (String) -> Void

    public init(isPresented: Binding<Bool>, list: [StorageBoxModel]?, onComplete: @escaping (String) -> Void) {
        _isPresented = isPresented
        duplicatedCheckList = list ?? []
        self.onComplete = onComplete
    }

    public func body(content: Content) -> some View {
        content
            .popup(isPresented: $isPresented, content: {
                LKTextFieldPopup(headerText: "새 폴더 추가",
                                 text: $newFolderName,
                                 fieldText: "폴더명",
                                 placeholder: "폴더명을 입력하세요",
                                 helperText: "같은 이름의 폴더가 있어요",
                                 textLimit: 15,
                                 isWarning: isDuplicatedNameCheck(),
                                 onCancel: {
                                     isPresented = false
                                     newFolderName = ""
                                 }, confirmText: "만들기",
                                 onConfirm: {
                                     if !isDuplicatedNameCheck() {
                                         isPresented = false
                                         onComplete(newFolderName)
                                         newFolderName = ""
                                     }
                                 })
            })
    }

    private func isDuplicatedNameCheck() -> Bool {
        duplicatedCheckList.contains(where: { $0.title.lowercased() == newFolderName.lowercased() })
    }
}
