//
//  LKCardProgressBar.swift
//  DesignSystemKit
//
//  Created by 안상희 on 7/12/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

struct LKCardProgressBar: View {
    var progress: CGFloat

    init(progress: CGFloat) {
        self.progress = progress
    }

    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .frame(
                    width: 350 * progress,
                    height: 4
                )
                .opacity(0.3)
                .foregroundColor(DesignSystemKitAsset.Colors.primary.swiftUIColor)
                .cornerRadius(99, corners: .allCorners)

            Spacer()
                .frame(width: 4)

            Rectangle()
                .frame(width: 350, height: 4)
                .foregroundStyle(DesignSystemKitAsset.Colors.gradient2)
                .cornerRadius(99, corners: .allCorners)

            Spacer()
                .frame(width: 5)
        }
    }
}

#Preview {
    LKCardProgressBar(progress: 0.5)
}
