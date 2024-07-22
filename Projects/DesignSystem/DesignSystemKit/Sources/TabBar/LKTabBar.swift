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
                VStack(spacing: 2) {
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
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(height: 48)
        .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
        .overlay {
            RoundedTopBorder()
                .stroke(DesignSystemKitAsset.Colors.g1.swiftUIColor, lineWidth: 1)
        }
        .shadow(color: .primary.opacity(0.01), blur: 8, x: 0, y: -4)
    }
}

// 바텀 탭 뷰의 상단의 일직선
private struct RoundedTopBorder: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: 0))
        return path
    }
}
