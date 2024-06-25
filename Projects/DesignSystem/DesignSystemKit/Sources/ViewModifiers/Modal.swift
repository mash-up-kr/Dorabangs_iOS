//
//  Modal.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/21/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public extension View {
    func modal<Content: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ZStack {
            self
            
            GeometryReader { geometry in
                if isPresented.wrappedValue {
                    Group {
                        DesignSystemKitAsset.Colors.dimmed.swiftUIColor
                            .transition(.opacity)
                        
                        content()
                            .position(
                                x: geometry.size.width / 2,
                                y: (geometry.size.height + geometry.safeAreaInsets.top) / 2
                            )
                    }
                    .ignoresSafeArea(.container)
                }
            }
        }
    }
}
