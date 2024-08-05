//
//  Popup.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/21/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public extension View {
    func popup(
        isPresented: Binding<Bool>,
        isDimmed: Bool = true,
        @ViewBuilder content: @escaping () -> some View
    ) -> some View {
        ZStack {
            self

            if isDimmed {
                DesignSystemKitAsset.Colors.dimmed.swiftUIColor
                    .ignoresSafeArea(.container)
                    .opacity(isPresented.wrappedValue ? 1 : 0)
                    .animation(.easeInOut, value: isPresented.wrappedValue)
            }

            if isPresented.wrappedValue {
                content()
            }
        }
    }
}
