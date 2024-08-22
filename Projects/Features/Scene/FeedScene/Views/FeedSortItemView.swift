//
//  FeedSortItemView.swift
//  Feed
//
//  Created by 박소현 on 7/9/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import SwiftUI

public struct FeedSortItemView: View {
    let image: Image
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    public init(image: Image, title: String, isSelected: Bool, onTap: @escaping () -> Void) {
        self.image = image
        self.title = title
        self.isSelected = isSelected
        self.onTap = onTap
    }

    public var body: some View {
        HStack(alignment: .center, spacing: 4) {
            image
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isSelected ? DesignSystemKitAsset.Colors.g9.swiftUIColor : DesignSystemKitAsset.Colors.g4.swiftUIColor)
                .frame(width: 24, height: 24)

            Text(title)
                .font(weight: .medium, semantic: .caption1)
                .foregroundStyle(isSelected ? DesignSystemKitAsset.Colors.g9.swiftUIColor : DesignSystemKitAsset.Colors.g4.swiftUIColor)
        }
        .frame(height: 24)
        .onTapGesture {
            onTap()
        }
    }
}
