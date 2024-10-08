//
//  FeedSortView.swift
//  Feed
//
//  Created by 박소현 on 7/8/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import LocalizationKit
import SwiftUI

public struct FeedSortView: View {
    let postCounts: Int
    let onSort: (SortType) -> Void

    @State var selectedType: SortType = .latest

    public enum SortType {
        case latest, past
    }

    public init(postCounts: Int, onSort: @escaping (SortType) -> Void) {
        self.postCounts = postCounts
        self.onSort = onSort
    }

    public var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Text(LocalizationKitStrings.FeedScene.postCountsReversed(postCounts))
                .font(weight: .medium, semantic: .s)
                .foregroundStyle(DesignSystemKitAsset.Colors.g6.swiftUIColor)
                .padding(.leading, 20)
            Spacer()
            FeedSortItemView(
                image: DesignSystemKitAsset.Icons.icDirectionDownEnabled.swiftUIImage,
                title: LocalizationKitStrings.FeedScene.latestSortTab,
                isSelected: selectedType == .latest,
                onTap: {
                    onSort(.latest)
                    selectedType = .latest
                }
            )
            FeedSortItemView(
                image: DesignSystemKitAsset.Icons.icDirectionUpEnabled.swiftUIImage,
                title: LocalizationKitStrings.FeedScene.pastSortTab,
                isSelected: selectedType == .past,
                onTap: {
                    onSort(.past)
                    selectedType = .past
                }
            )
            .padding(.trailing, 20)
        }
        .frame(height: 44)
        .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
    }
}
