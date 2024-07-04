//
//  HomeBannerPageControlView.swift
//  DesignSystemKit
//
//  Created by 안상희 on 7/4/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct HomeBannerPageControlView: View {
    private let count: Int
    @State var selectedIndex: Int

    public init(count: Int, selectedIndex: Int) {
        self.count = count
        self.selectedIndex = selectedIndex
    }

    public var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 6) {
                ForEach(0..<count) { index in
                    if index == selectedIndex {
                        DesignSystemKitAsset.Icons.icStar.swiftUIImage
                            .frame(width: 8, height: 8)
                    } else {
                        // ic_dot으로 변경 필요
                        Image(.icDot)
                            .frame(width: 4, height: 4)
                    }
                }
            }
        }
        .padding(.horizontal, 8)
        .frame(height: 16)
        .background(
            AngularGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0.9, green: 0.93, blue: 1).opacity(0.1), location: 0.05),
                    Gradient.Stop(color: Color(red: 0.47, green: 0.78, blue: 1).opacity(0.1), location: 0.25),
                    Gradient.Stop(color: Color(red: 0.67, green: 0.74, blue: 1).opacity(0.1), location: 0.50),
                    Gradient.Stop(color: Color(red: 0.84, green: 0.59, blue: 1).opacity(0.1), location: 0.75),
                    Gradient.Stop(color: Color(red: 0.65, green: 0.6, blue: 1).opacity(0.1), location: 1.00)
                ],
                center: UnitPoint(x: 0.5, y: 0.5),
                angle: Angle(degrees: 45)
            )
        )
        .cornerRadius(50, corners: .allCorners)
    }
}

#Preview {
    HomeBannerPageControlView(count: 3, selectedIndex: 0)
}
