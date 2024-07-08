//
//  FeedHeaderTabItemView.swift
//  Feed
//
//  Created by 박소현 on 7/9/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import SwiftUI

public struct FeedHeaderTabItemView: View {
    let title: String
    var isSelected: Bool = false
    var onTap: () -> Void

    public init(title: String, isSelected: Bool, onTap: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.onTap = onTap
    }

    public var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(title)
                .font(weight: .medium, semantic: .caption2)
                .foregroundStyle(isSelected ? DesignSystemKitAsset.Colors.g9.swiftUIColor : DesignSystemKitAsset.Colors.g4.swiftUIColor)
                .frame(height: 22)

            Circle()
                .frame(width: 3, height: 3)
                .background(isSelected ? DesignSystemKitAsset.Colors.g9.swiftUIColor : DesignSystemKitAsset.Colors.g4.swiftUIColor)
        }
        .frame(height: 30)
        .onTapGesture(perform: {
            onTap()
        })
    }
}
