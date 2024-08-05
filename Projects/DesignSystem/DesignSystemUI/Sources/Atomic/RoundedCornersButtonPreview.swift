//
//  RoundedCornersButtonPreview.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/19/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import SwiftUI

struct RoundedCornersButtonPreview: View {
    @State private var title: String = "버튼"
    @State private var selectedIndex: Int = 0
    private let styles = RoundedCornersButton.Style.allCases

    var body: some View {
        ComponentPreview(
            component: {
                RoundedCornersButton(
                    title: title,
                    style: styles[selectedIndex],
                    action: {}
                )
                .padding(.horizontal, 20)
            },
            options: [
                .textField(description: "title", text: $title),
                .picker(description: "style", cases: styles, selectedIndex: $selectedIndex)
            ]
        )
        .navigationTitle("RoundedCornersButton")
    }
}

private extension RoundedCornersButton.Style {
    static var allCases: [RoundedCornersButton.Style] {
        [.solidBlack, .solidGray]
    }
}

#Preview {
    RoundedCornersButtonPreview()
}
