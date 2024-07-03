//
//  BottomSheet.swift
//  DesignSystemUI
//
//  Created by 박소현 on 6/29/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

extension View {
    public func bottomSheet(
        isPresented: Binding<Bool>,
        folders: [String],
        onComplete: @escaping (String?) -> Void
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
                    
                    FolderBottomSheet(
                        isPresented: isPresented,
                        folders: folders,
                        onComplete: onComplete
                    )
                    .zIndex(2)
                    .transition(.move(edge: .bottom))
                }
            }
            .ignoresSafeArea()
        }
    }
}
