//
//  BannerButtonPreview.swift
//  DesignSystemUI
//
//  Created by 안상희 on 7/4/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import SwiftUI

struct BannerButtonPreview: View {
    @State private var title: String = "확인하기"

    var body: some View {
        ComponentPreview(
            component: {
                BannerButton(
                    title: title,
                    action: {}
                )
                .padding(.horizontal, 20)
            },
            options: [
                .textField(description: "title", text: $title)
            ]
        )
        .navigationTitle("RoundedButton")
    }
}

#Preview {
    BannerButtonPreview()
}
