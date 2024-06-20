//
//  TextFieldPreview.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/20/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import SwiftUI

struct TextFieldPreview: View {
    @State private var text: String = ""
    @State private var fieldText: String? = "폴더명"
    @State private var placeholder: String? = "폴더명을 입력하세요."
    @State private var helperText: String? = "같은 이름의 폴더가 있어요"
    @State private var textLimit: Int? = 10
    @State private var isWarning: Bool = false
    
    var body: some View {
        ComponentPreview(
            component: {
                LKTextField(
                    text: $text,
                    fieldText: fieldText,
                    placeholder: placeholder,
                    helperText: helperText,
                    textLimit: textLimit,
                    isWarning: isWarning
                )
            },
            options: [
                .optionalString(description: "fieldText", text: $fieldText),
                .optionalString(description: "placeholder", text: $placeholder),
                .optionalString(description: "helperText", text: $helperText),
                .optionalInt(description: "textLimit", value: $textLimit),
                .toggle(description: "isWarning", isOn: $isWarning)
            ]
        )
        .navigationTitle("TextField")
    }
}

#Preview {
    TextFieldPreview()
}
