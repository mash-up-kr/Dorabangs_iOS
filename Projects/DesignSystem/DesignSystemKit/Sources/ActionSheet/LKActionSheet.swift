//
//  LKActionSheet.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/27/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct LKActionSheet: View {
    @State private var yOffset: CGFloat = 0
    @Binding private var isPresented: Bool
    private let items: [LKActionItem]
    private let actionSheetHeight: CGFloat = 320

    public init(
        isPresented: Binding<Bool>,
        items: [LKActionItem]
    ) {
        _isPresented = isPresented
        self.items = items
    }

    public var body: some View {
        VStack(spacing: 0) {
            DragIndicator(type: .dark)
                .padding(.top, 12)

            ActionList(items: items)
                .padding(.top, 19)
                .padding(.horizontal, 16)
        }
        .frame(height: actionSheetHeight, alignment: .top)
        .background(DesignSystemKitAsset.Colors.g2.swiftUIColor)
        .cornerRadius(16, corners: [.topLeft, .topRight])
        .shadow(
            color: DesignSystemKitAsset.Colors.topShadow.swiftUIColor,
            blur: 12,
            x: 0,
            y: -10
        )
        .offset(y: yOffset)
        .gesture(dragGesture)
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                yOffset = max(0, value.translation.height)
            }
            .onEnded { value in
                withAnimation(.easeInOut(duration: 0.3)) {
                    let threshold = actionSheetHeight * 0.5
                    if value.translation.height > threshold {
                        isPresented = false
                    } else {
                        yOffset = 0
                    }
                }
            }
    }
}

public struct DragIndicator: View {
    public enum ColorType { case dark, light }
    private let type: ColorType

    public init(type: ColorType = .dark) {
        self.type = type
    }

    public var body: some View {
        HStack {
            Spacer()

            type.image
                .resizable()
                .frame(width: 36, height: 5)

            Spacer()
        }
    }
}

extension DragIndicator.ColorType {
    var image: Image {
        switch self {
        case .dark: DesignSystemKitAsset.Icons.icHandlerDark.swiftUIImage
        case .light: DesignSystemKitAsset.Icons.icHandlerLight.swiftUIImage
        }
    }
}

private struct ActionList: View {
    let items: [LKActionItem]

    var body: some View {
        VStack(spacing: 0) {
            ForEach(items.indices, id: \.self) { index in
                if index > 0 {
                    LKDivider()
                        .padding(.horizontal, 16)
                }

                ActionItem(item: items[index])
                    .padding(16)
            }
        }
        .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
        .cornerRadius(12, corners: .allCorners)
    }
}

private struct ActionItem: View {
    let item: LKActionItem

    var body: some View {
        HStack(spacing: 12) {
            if let image = item.image {
                image
                    .resizable()
                    .frame(width: 24, height: 24)
            }

            Text(item.title)
                .font(weight: .medium, semantic: .caption3)
                .foregroundStyle(
                    item.style == .default
                        ? DesignSystemKitAsset.Colors.g9.swiftUIColor
                        : DesignSystemKitAsset.Colors.alert.swiftUIColor
                )

            Spacer()
        }
        .frame(height: 24)
        .onTapGesture(perform: item.action ?? {})
    }
}

#Preview {
    LKActionSheet(
        isPresented: .constant(true),
        items: [
            .init(
                title: "폴더 삭제",
                image: DesignSystemKitAsset.Icons.icCircleAlert.swiftUIImage,
                style: .destructive
            ),
            .init(title: "폴더 이름 변경", style: .default)
        ]
    )
}
