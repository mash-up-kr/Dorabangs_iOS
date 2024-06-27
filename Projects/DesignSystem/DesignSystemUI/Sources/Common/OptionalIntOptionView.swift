//
//  OptionalIntOptionView.swift
//  DesignSystemUI
//
//  Created by 김영균 on 6/20/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import SwiftUI

struct OptionalIntOptionView: View {
    private let description: String
    @Binding private var value: Int?
    @State private var placeholder: Int?

    init(description: String, value: Binding<Int?>) {
        self.description = description
        _value = value
        _placeholder = State(initialValue: value.wrappedValue)
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(description)
                        .font(.system(size: 15, weight: .bold))

                    Text("Optional<Int>")
                        .font(.system(size: 13, weight: .regular))
                }

                Spacer()

                Toggle(
                    "",
                    isOn: Binding(
                        get: { value != nil },
                        set: { isOn in
                            isOn ? (value = placeholder) : (value = nil)
                        }
                    )
                )
                .tint(.secondary)
                .labelsHidden()
            }

            Spacer()

            TextField(
                "",
                value: Binding(
                    get: { placeholder },
                    set: { value in
                        placeholder = value
                        self.value = value
                    }
                ),
                format: .number
            )
            .font(.system(size: 15, weight: .regular))
            .padding(16)
            .foregroundColor(value != nil ? Color(uiColor: .label) : Color(uiColor: .secondaryLabel))
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(8, corners: .allCorners)
            .keyboardType(.numberPad)
        }
    }
}
