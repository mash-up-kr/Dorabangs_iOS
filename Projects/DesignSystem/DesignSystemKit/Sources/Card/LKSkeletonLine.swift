//
//  LKSkeletonLine.swift
//  DesignSystemKit
//
//  Created by 안상희 on 7/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

struct LKSkeletonLine: View {
    let primaryColor: Color
    let containerColor: Color
    @Binding var animate: Bool

    var body: some View {
        GeometryReader { geometry in
            let colors = [
                containerColor.opacity(0.7),
                primaryColor.opacity(0.4),
                containerColor.opacity(0.7)
            ]
            let gradient = LinearGradient(
                gradient: Gradient(colors: colors),
                startPoint: .leading,
                endPoint: .trailing
            )

            RoundedRectangle(cornerRadius: 4)
                .fill(gradient)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .offset(x: animate ? geometry.size.width : -geometry.size.width)
                .mask(
                    RoundedRectangle(cornerRadius: 4)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                )
                .animation(Animation.linear(duration: Double.random(in: 1.3 ... 2.5)).repeatForever(autoreverses: false), value: animate)
        }
        .frame(height: 14)
    }
}

#Preview {
    LKSkeletonLine(
        primaryColor: DesignSystemKitAsset.Colors.primary.swiftUIColor,
        containerColor: DesignSystemKitAsset.Colors.white.swiftUIColor,
        animate: .constant(false)
    )
}
