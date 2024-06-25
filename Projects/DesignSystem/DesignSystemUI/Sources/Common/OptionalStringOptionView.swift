//
//  OptionalStringOptionView.swift
//  DesignSystemUI
//
//  Created by 김영균 on 6/20/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

struct OptionalStringOptionView: View {
    let description: String
    @Binding var text: String?
    @State private var placeholder: String
    
    init(description: String, text: Binding<String?>) {
        self.description = description
        self._text = text
        self._placeholder = State(initialValue: text.wrappedValue ?? "")
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(description)
                        .font(.system(size: 15, weight: .bold))
                    
                    Text("Optional<String>")
                        .font(.system(size: 13, weight: .regular))
                }
                
                Spacer()
                
                Toggle(
                    "",
                    isOn: Binding(
                        get: { text != nil },
                        set: { isOn in
                            if !isOn {
                                dismissKeyboard()
                            }
                            isOn ? (text = placeholder) : (text = nil)
                        }
                    )
                )
                .tint(.secondary)
                .labelsHidden()
            }
            
            TextField(
                "",
                text: Binding(
                    get: { placeholder },
                    set: { text in
                        placeholder = text
                        self.text = text
                    }
                )
            )
            .font(.system(size: 15, weight: .regular))
            .padding(16)
            .foregroundColor(text != nil ? Color(uiColor: .label) : Color(uiColor: .secondaryLabel))
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(8, corners: .allCorners)
            .disabled(text == nil)
        }
    }
    
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
