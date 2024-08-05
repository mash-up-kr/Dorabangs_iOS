//
//  ToggleOptionView.swift
//  DesignSystemUI
//
//  Created by 김영균 on 6/19/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

struct ToggleOptionView: View {
    let description: String
    @Binding var isOn: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text(description)
                .font(.system(size: 15, weight: .bold))

            Text("Bool")
                .font(.system(size: 13, weight: .regular))

            Toggle("", isOn: $isOn)
                .tint(.primary)
                .labelsHidden()
        }
    }
}
