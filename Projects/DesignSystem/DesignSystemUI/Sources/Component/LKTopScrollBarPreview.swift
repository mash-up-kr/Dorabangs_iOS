//
//  LKTopScrollBarPreview.swift
//  DesignSystemUI
//
//  Created by 안상희 on 6/30/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import SwiftUI

struct LKTopScrollBarPreview: View {
    @State private var selectedIndex: Int = 0
    @State private var titleList: [String] = ["전체", "즐겨찾기", "나중에 읽을 링크", "나즁에 또 읽을 링크", "영원히 안 볼 링크"]
    @State private var title: String = "제목이어용"

    var body: some View {
        ComponentPreview(
            component: {
                LKTopScrollBar(
                    titleList: titleList,
                    selectedIndex: selectedIndex
                )
            },
            options: [
                .addText(description: "입력해서 리스트 추가하기", textList: $titleList, text: $title)
            ]
        )
        .navigationBarTitle("LKTopScrollBar")
    }
}

#Preview {
    LKTopScrollBarPreview()
}
