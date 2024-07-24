//
//  KeywordView.swift
//  Onboarding
//
//  Created by 김영균 on 7/6/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import SwiftUI

struct KeywordView: View {
    @State private var isSelected: Bool = false
    private let title: String
    private var onSelect: (() -> Void)?

    public init(title: String, onSelect: (() -> Void)? = nil) {
        self.title = title
        self.onSelect = onSelect
    }

    var body: some View {
        Text(title)
            .keywordStyle(isSelected: isSelected)
            .onTapGesture {
                isSelected.toggle()
                onSelect?()
            }
    }
}

private extension View {
    @ViewBuilder
    func keywordStyle(isSelected: Bool) -> some View {
        if isSelected {
            modifier(SelectBackground())
        } else {
            modifier(DeselectBackground())
        }
    }
}

private struct DeselectBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(weight: .medium, semantic: .caption2)
            .lineLimit(1)
            .foregroundStyle(DesignSystemKitAsset.Colors.g9.swiftUIColor)
            .padding(.horizontal, 20)
            .padding(.vertical, 6)
            .frame(height: 40)
            .background(DesignSystemKitAsset.Colors.g1.swiftUIColor)
            .cornerRadius(99.9, corners: .allCorners)
            .border(DesignSystemKitAsset.Colors.g2.swiftUIColor, width: 1, cornerRadius: 99.9)
    }
}

private struct SelectBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(weight: .medium, semantic: .caption2)
            .lineLimit(1)
            .foregroundStyle(DesignSystemKitAsset.Colors.gradient3)
            .padding(.horizontal, 20)
            .padding(.vertical, 6)
            .frame(height: 40)
            .background(DesignSystemKitAsset.Colors.g9.swiftUIColor)
            .cornerRadius(99.9, corners: .allCorners)
            .border(DesignSystemKitAsset.Colors.gradient4, width: 1, cornerRadius: 99.9)
    }
}
