//
//  IntOptionView.swift
//  DesignSystemUI
//
//  Created by 안상희 on 6/30/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import SwiftUI

struct IntOptionView: View {
    private let description: String
    @Binding private var value: Int
    @State private var placeholder: Int

    init(description: String, value: Binding<Int>) {
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

                    Text("<Int>")
                        .font(.system(size: 13, weight: .regular))
                }

                Spacer()

                Toggle(
                    "",
                    isOn: Binding(
                        get: { true },
                        set: { isOn in
                            isOn ? (value = placeholder) : (value = 0)
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
            .foregroundColor(Color(uiColor: .label))
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(8, corners: .allCorners)
            .keyboardType(.numberPad)
        }
    }
}
