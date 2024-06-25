//
//  popup.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/21/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public extension View {
    func popup<Content: View>(
        isPresented: Binding<Bool>,
        isDimmed: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ZStack {
            self
            
            if isDimmed {
                DesignSystemKitAsset.Colors.dimmed.swiftUIColor
                    .ignoresSafeArea(.container)
                    .animation(.easeInOut) { content in
                        content.opacity(isPresented.wrappedValue ? 1 : 0)
                    }
            }
            
            if isPresented.wrappedValue {
                content()
            }
        }
    }
}
