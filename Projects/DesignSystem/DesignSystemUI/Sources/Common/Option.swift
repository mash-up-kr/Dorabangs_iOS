//
//  Option.swift
//  DesignSystemUI
//
//  Created by 김영균 on 6/19/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

enum Option: View {
    case toggle(description: String, isOn: Binding<Bool>)
    case picker(description: String, cases: [Any], selectedIndex: Binding<Int>)
    case textField(description: String, text: Binding<String>)
    case optionalString(description: String, text: Binding<String?>)
    case optionalInt(description: String, value: Binding<Int?>)

    @ViewBuilder
    var body: some View {
        switch self {
        case let .toggle(description, isOn):
            ToggleOptionView(description: description, isOn: isOn)
        case let .picker(description, cases, selectedIndex):
            PickerOptionView(description: description, cases: cases, selectedIndex: selectedIndex)
        case let .textField(description, text):
            TextFieldOptionView(description: description, text: text)
        case let .optionalString(description, text):
            OptionalStringOptionView(description: description, text: text)
        case let .optionalInt(description, value):
            OptionalIntOptionView(description: description, value: value)
        }
    }
}

struct OptionItem: View {
    let option: Option

    var body: some View {
        VStack(alignment: .leading) {
            option.body
            Divider()
        }
        .padding(8)
    }
}
