//
//  LKTabBar.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/24/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct LKTabBar<SelectionValue: Hashable>: View {
    @Binding var selection: SelectionValue
    let tabItems: [LKTabBarItem<SelectionValue>]

    public init(selection: Binding<SelectionValue>, tabItems: [LKTabBarItem<SelectionValue>]) {
        _selection = selection
        self.tabItems = tabItems
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(tabItems) { item in
                VStack(spacing: 4) {
                    (selection == item.tag ? item.selectedImage : item.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)

                    Text(item.title)
                        .font(weight: .medium, semantic: .xs)
                        .foregroundStyle(
                            selection == item.tag
                                ? DesignSystemKitAsset.Colors.g9.swiftUIColor
                                : DesignSystemKitAsset.Colors.g4.swiftUIColor
                        )
                }
                .onTapGesture {
                    selection = item.tag
                }
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(height: 60)
        .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
        .overlay {
            RoundedTopCornersBorder(radius: 20)
                .stroke(DesignSystemKitAsset.Colors.g2.swiftUIColor, lineWidth: 1)
        }
    }
}

// 바텀 탭 뷰의 상단을 둥글게 하는 Shape
private struct RoundedTopCornersBorder: Shape {
    let radius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 0, y: radius * 2))
        path.addLine(to: CGPoint(x: 0, y: radius))
        path.addArc(
            center: CGPoint(x: radius, y: radius),
            radius: radius,
            startAngle: .degrees(180),
            endAngle: .degrees(270),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: rect.maxX - radius, y: 0))
        path.addArc(
            center: CGPoint(x: rect.maxX - radius, y: radius),
            radius: radius,
            startAngle: .degrees(270),
            endAngle: .degrees(0),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: rect.maxX, y: radius * 2))
        return path
    }
}
