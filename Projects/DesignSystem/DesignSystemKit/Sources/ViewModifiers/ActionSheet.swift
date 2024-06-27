//
//  ActionSheet.swift
//  DesignSystemUI
//
//  Created by 김영균 on 6/26/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

extension View {
    public func actionSheet(
        isPresented: Binding<Bool>,
        items: [LKActionItem]
    ) -> some View {
        ZStack {
            self
            
            ZStack(alignment: .bottom) {
                if isPresented.wrappedValue {
                    DesignSystemKitAsset.Colors.dimmed.swiftUIColor
                        .zIndex(1)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                isPresented.wrappedValue = false
                            }
                        }
                    
                    LKActionSheet(isPresented: isPresented, items: items)
                        .zIndex(2)
                        .transition(.move(edge: .bottom))
                }
            }
            .ignoresSafeArea()
        }
    }
}
