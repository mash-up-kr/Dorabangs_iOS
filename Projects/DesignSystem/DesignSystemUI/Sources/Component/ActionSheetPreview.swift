//
//  ActionSheetPreview.swift
//  DesignSystemUI
//
//  Created by 김영균 on 6/27/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import SwiftUI

struct ActionSheetPreview: View {
    @State private var isPresented: Bool = false
    @State private var title: String = "폴더 삭제"
    @State private var isImagePresented: Bool = true
    private var image: Image? {
        isImagePresented ? DesignSystemKitAsset.Icons.icCircleAlert.swiftUIImage : nil
    }
    
    var body: some View {
        ComponentPreview(
            component: {
                LKActionSheet(
                    isPresented: .constant(true),
                    items: [
                        .init(title: title, image: image, style: .default),
                        .init(title: title, image: image, style: .destructive)
                    ]
                )
            },
            options: [
                .textField(description: "title", text: $title),
                .toggle(description: "image", isOn: $isImagePresented)
                
            ]
        )
        .navigationTitle("ActionSheet")
        .toolbar {
            Button("Preview") {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isPresented = true
                }
            }
        }
        .actionSheet(
            isPresented: $isPresented,
            items: [
                .init(title: title, image: image, style: .default),
                .init(title: title, image: image, style: .destructive)
            ]
        )
    }
}

#Preview {
    ActionSheetPreview()
}
