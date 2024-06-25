//
//  ModalPreview.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/21/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import SwiftUI

struct ModalPreview: View {
    @State private var isPresented: Bool = false
    @State private var title: String = "링크 삭제"
    @State private var content: String = "한 번 삭제한 링크는 다시 복구할 수 없어요.\n그래도 삭제하시겠어요?"
    @State private var leftButtonTitle: String = "취소"
    @State private var rightButtonTitle: String = "삭제"
    
    var body: some View {
        ComponentPreview(
            component: modal,
            options: [
                .textField(description: "title", text: $title),
                .textField(description: "content", text: $content),
                .textField(description: "leftButtonTitle", text: $leftButtonTitle),
                .textField(description: "rightButtonTitle", text: $rightButtonTitle)
            ]
        )
        .navigationBarTitle("Modal")
        .toolbar { Button("Preview") { isPresented.toggle() }}
        .modal(isPresented: $isPresented, content: modal)
    }
    
    @ViewBuilder
    func modal() -> some View {
        LKModal(
            title: title,
            content: content,
            leftButtonTitle: leftButtonTitle,
            leftButtonAction: { isPresented = false },
            rightButtonTitle: rightButtonTitle,
            rightButtonAction: { isPresented = false }
        )
    }
}
