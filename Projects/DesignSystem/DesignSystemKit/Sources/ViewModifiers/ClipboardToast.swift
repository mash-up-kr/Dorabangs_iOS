//
//  ClipboardToast.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/26/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation
import SwiftUI

public extension View {
    func clipboardToast(
        isPresented: Binding<Bool>,
        urlString: String,
        saveAction: @escaping () -> Void
    ) -> some View {
        modifier(
            ClipboardToastModifier(isPresented: isPresented, urlString: urlString, saveAction: saveAction)
        )
    }
}

private struct ClipboardToastModifier: ViewModifier {
    @State private var workItem: DispatchWorkItem?
    @Binding var isPresented: Bool
    var urlString: String
    var saveAction: () -> Void
    let duration: CGFloat = 2
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                VStack {
                    Spacer()
                    
                    LKClipboardToast(
                        urlString: urlString,
                        saveAction: saveAction,
                        closeAction: hideToast
                    )
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
                }
                .transition(.opacity.animation(.easeInOut))
                .onAppear(perform: showToast)
            }
        }
    }
    
    private func showToast() {
        guard isPresented else { return }
        workItem?.cancel()
        let task = DispatchWorkItem(block: hideToast)
        workItem = task
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: task)
    }
    
    private func hideToast() {
        withAnimation { isPresented = false }
        workItem?.cancel()
        workItem = nil
    }
}
