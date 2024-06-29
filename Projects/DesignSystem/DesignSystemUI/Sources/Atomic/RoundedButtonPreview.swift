//
//  RoundedButtonPreview.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/19/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import SwiftUI

struct RoundedButtonPreview: View {
    @State private var title: String = "버튼"
    @State private var isDisabled: Bool = false

    var body: some View {
        ComponentPreview(
            component: {
                RoundedButton(
                    title: title,
                    isDisabled: isDisabled,
                    action: {}
                )
                .padding(.horizontal, 20)
            },
            options: [
                .textField(description: "title", text: $title),
                .toggle(description: "isDisabled", isOn: $isDisabled)
            ]
        )
        .navigationTitle("RoundedButton")
    }
}

#Preview {
    RoundedButtonPreview()
}
