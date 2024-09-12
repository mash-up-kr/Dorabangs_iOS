//
//  LKKeywordSkeletonView.swift
//  DesignSystemKit
//
//  Created by 안상희 on 7/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

struct LKKeywordSkeletonView: View {
    @State private var animate = false

    private let primaryColor = DesignSystemKitAsset.Colors.primary500.swiftUIColor
    private let containerColor = DesignSystemKitAsset.Colors.white.swiftUIColor

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 10)

            LKSkeletonLine(
                primaryColor: containerColor,
                containerColor: primaryColor,
                animate: $animate
            )
            .frame(height: 14)

            Spacer()
                .frame(height: 10)
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                animate = true
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 66)
    }
}

#Preview {
    LKKeywordSkeletonView()
}
