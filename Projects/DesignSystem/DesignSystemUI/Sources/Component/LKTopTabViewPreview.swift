//
//  LKTopTabViewPreview.swift
//  DesignSystemUI
//
//  Created by 안상희 on 6/30/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import SwiftUI

struct LKTopTabViewPreview: View {
    @State private var isSelected: Bool = false
    @State private var title: String = "나중에 읽을 링크"
    @State private var count: String = ""

    var body: some View {
        ComponentPreview(
            component: {
                LKTopTabView(
                    isSelected: isSelected,
                    title: title,
                    count: count
                )
            },
            options: [
                .textField(description: "제목", text: $title),
                .textField(description: "갯수", text: $count),
                .toggle(description: "선택", isOn: $isSelected)
            ]
        )
        .navigationBarTitle("LKTopTabView")
    }
}

#Preview {
    LKTopTabViewPreview()
}
