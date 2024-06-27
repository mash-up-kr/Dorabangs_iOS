//
//  ClipboardToastPreview.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/26/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import SwiftUI

struct ClipboardToastPreview: View {
    @State private var isPresented: Bool = false
    @State private var urlString: String = "https://www.apple.com"
    
    var body: some View {
        ComponentPreview(
            component: {
                LKClipboardToast(
                    urlString: urlString,
                    saveAction: {},
                    closeAction: {}
                )
                .padding(.horizontal, 20)
            },
            options: [
                .textField(description: "urlString", text: $urlString),
            ]
        )
        .navigationTitle("ClipboardToast")
        .toolbar { Button("Preview") { isPresented = true }}
        .clipboardToast(
            isPresented: $isPresented,
            urlString: urlString,
            saveAction: {}
        )
    }
}

#Preview {
    ClipboardToastPreview()
}
