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
        GeometryReader { geometry in
            HStack(spacing: 0) {
                if progress != 0 {
                    Rectangle()
                        .frame(
                            width: geometry.size.width * progress,
                            height: 4
                        )
                        .foregroundColor(DesignSystemKitAsset.Colors.primary.swiftUIColor)
                        .cornerRadius(99, corners: .allCorners)

                    Spacer()
                        .frame(width: 4)
                }

                Rectangle()
                    .frame(width: max(geometry.size.width - geometry.size.width * progress - 4, geometry.size.width))
                    .frame(height: 4)
                    .foregroundStyle(DesignSystemKitAsset.Colors.gradient2)
                    .cornerRadius(99, corners: .allCorners)
            }
            .preference(key: ViewSizeKey.self, value: geometry.size)
        }
        .frame(maxWidth: .infinity)
    }
}

private struct ViewSizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

#Preview {
    LKCardProgressBar(progress: 0.3)
}
