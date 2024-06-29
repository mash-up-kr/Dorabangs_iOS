//
//  LKClassificationCardPreview.swift
//  DesignSystemUI
//
//  Created by 안상희 on 6/28/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import SwiftUI

struct LKClassificationCardPreview: View {
    @State private var title: String = "에스파 '슈퍼노바', 올해 멜론 주간 차트 최장 1위…'쇠맛' 흥행 질주"
    @State private var description: String = "사건은 다가와 아 오 에 거세게 커져가 아 오 에 That tick, that tick, tick bomb That tick, that tick, tick bomb"
    @State private var tags: [String] = ["# 에스파", "# SM", "# 오에이옹에이옹"]
    @State private var category: String = "Category"
    @State private var timeSince: String = "1일 전"
    @State private var buttonTitle: String = "디자인(으)로 옮기기"
    
    var body: some View {
        ComponentPreview(
            component: {
                LKClassificationCard(
                    title: title,
                    description: description,
                    tags: tags,
                    category: category,
                    timeSince: timeSince, 
                    buttonTitle: buttonTitle,
                    deleteAction: {},
                    moveToFolderAction: {}
                )
            },
            options: [
                .textField(description: "제목", text: $title),
                .textField(description: "주요 내용", text: $description),
                .textField(description: "카테고리", text: $category),
                .textField(description: "저장 기간", text: $timeSince)
            ]
        )
        .navigationBarTitle("LKClassificationCard")
    }
}

#Preview {
    LKClassificationCardPreview()
}
