//
//  FeedSortView.swift
//  Feed
//
//  Created by 박소현 on 7/8/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import SwiftUI

public struct FeedSortView: View {
    let onSort: (SortType) -> Void

    @State var selectedType: SortType = .latest

    public enum SortType {
        case latest, past
    }

    public init(onSort: @escaping (SortType) -> Void) {
        self.onSort = onSort
    }

    public var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Spacer()
            FeedSortItemView(image: DesignSystemKitAsset.Icons.icArrowDown.swiftUIImage, title: "최신순", isSelected: selectedType == .latest, onTap: {
                onSort(.latest)
                selectedType = .latest

            })
            FeedSortItemView(image: DesignSystemKitAsset.Icons.icArrowUp.swiftUIImage, title: "과거순", isSelected: selectedType == .past, onTap: {
                onSort(.past)
                selectedType = .past
            })
            .padding(.trailing, 20)
        }
        .frame(height: 54)
        .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
    }
}
