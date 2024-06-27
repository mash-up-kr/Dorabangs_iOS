//
//  ToastPreview.swift
//  DesignSystemUI
//
//  Created by 김영균 on 6/24/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import SwiftUI

struct ToastPreview: View {
    @State private var isPresented: Bool = false
    @State private var selectedIndex: Int = 0
    @State private var message: String = "toast"

    var body: some View {
        ComponentPreview(
            component: {
                LKToast(type: LKToast.ToastType.allCases[selectedIndex], message: message)
            },
            options: [
                .picker(
                    description: "toastType",
                    cases: LKToast.ToastType.allCases,
                    selectedIndex: $selectedIndex
                ),
                .textField(description: "message", text: $message)
            ]
        )
        .navigationTitle("Toast")
        .toolbar { Button("Preview") { isPresented.toggle() }}
        .toast(
            isPresented: $isPresented,
            type: LKToast.ToastType.allCases[selectedIndex],
            message: message
        )
    }
}

private extension LKToast.ToastType {
    static var allCases: [LKToast.ToastType] {
        [.info, .warning]
    }
}

#Preview {
    ToastPreview()
}
