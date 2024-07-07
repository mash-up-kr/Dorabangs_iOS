//
//  Toast.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/24/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public extension View {
    func toast(
        isPresented: Binding<Bool>,
        type: LKToast.ToastType,
        message: String,
        duration: TimeInterval = 2,
        isEmbedTabbar: Bool?
    ) -> some View {
        modifier(
            ToastModifier(
                isPresented: isPresented,
                type: type,
                message: message,
                duration: duration,
                isEmbedTabbar: isEmbedTabbar
            )
        )
    }
}

struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    var type: LKToast.ToastType
    var message: String
    var duration: TimeInterval
    var isEmbedTabbar: Bool?

    func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                VStack {
                    Spacer()

                    LKToast(type: type, message: message)
                        .padding(.bottom, isEmbedTabbar == true ? 80 : 20)
                }
                .transition(.opacity.animation(.easeInOut))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        withAnimation {
                            isPresented = false
                        }
                    }
                }
            }
        }
    }
}
