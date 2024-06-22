//
//  TextFieldPopupPreview.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/21/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import SwiftUI

struct TextFieldPopupPreview: View {
    @State private var isPresented: Bool = false
    @State private var headerText: String? = "새폴더추가"
    @State private var text: String = ""
    @State private var fieldText: String? = "폴더명"
    @State private var placeholder: String? = "폴더명을 입력하세요."
    @State private var helperText: String? = "같은 이름의 폴더가 있어요"
    @State private var textLimit: Int? = 15
    @State private var isWarning: Bool = false
    @State private var confirmText: String = "만들기"
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ComponentPreview(
            component: popup,
            options: [
                .optionalString(description: "headerText", text: $headerText),
                .optionalString(description: "fieldText", text: $fieldText),
                .optionalString(description: "placeholder", text: $placeholder),
                .optionalString(description: "helperText", text: $helperText),
                .optionalInt(description: "textLimit", value: $textLimit),
                .toggle(description: "isWarning", isOn: $isWarning),
                .textField(description: "confirmText", text: $confirmText),
            ]
        )
        .navigationTitle("TextFieldPopup")
        .toolbar { Button("Preview") { isPresented.toggle() }}
        .popup(isPresented: $isPresented, content: popup)
    }
    
    func popup() ->  some View {
        LKTextFieldPopup(
            headerText: headerText,
            text: $text,
            fieldText: fieldText,
            placeholder: placeholder,
            helperText: helperText,
            textLimit: textLimit,
            isWarning: isWarning,
            onCancel: {
                isFocused = false
                isPresented = false
            },
            confirmText: confirmText,
            onConfirm: {
                isFocused = false
                isPresented = false
            }
        )
        .focused($isFocused)
        .onAppear {
            if isPresented {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    isFocused = true
                }
            }
        }
    }
}

#Preview {
    TextFieldPopupPreview()
}
