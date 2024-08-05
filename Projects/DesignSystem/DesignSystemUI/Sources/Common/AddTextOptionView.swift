//
//  AddTextOptionView.swift
//  DesignSystemUI
//
//  Created by 안상희 on 7/3/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import SwiftUI

struct AddTextOptionView: View {
    let description: String
    @Binding var textList: [String]
    @Binding private var text: String

    init(description: String, textList: Binding<[String]>, text: Binding<String>) {
        self.description = description
        _textList = textList
        _text = text
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(description)
                        .font(.system(size: 15, weight: .bold))

                    Text("String")
                        .font(.system(size: 13, weight: .regular))
                }

                Spacer()

                Button {
                    if !text.isEmpty {
                        textList.append(text)
                        text = ""
                    }
                } label: {
                    Text("추가하기!")
                }
            }

            TextField("", text: $text)
                .font(.system(size: 15, weight: .regular))
                .padding(16)
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(8, corners: .allCorners)
        }
    }
}
