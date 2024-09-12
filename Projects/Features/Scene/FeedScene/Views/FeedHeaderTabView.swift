//
//  FeedHeaderTabView.swift
//  Feed
//
//  Created by 박소현 on 7/9/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import LocalizationKit
import SwiftUI

public enum FeedViewType {
    case all, unread
}

public struct FeedHeaderTabView: View {
    public let select: (FeedViewType) -> Void
    @Binding var selectedType: FeedViewType

    public init(select: @escaping (FeedViewType) -> Void, selectedType: Binding<FeedViewType>) {
        self.select = select
        _selectedType = selectedType
    }

    public var body: some View {
        HStack(alignment: .center, spacing: 8) {
            LKTopTabView(isSelected: selectedType == .all, title: LocalizationKitStrings.Common.all)
                .onTapGesture {
                    select(.all)
                    selectedType = .all
                }

            LKTopTabView(isSelected: selectedType == .unread, title: LocalizationKitStrings.FeedScene.unreadTab)
                .onTapGesture {
                    select(.unread)
                    selectedType = .unread
                }

            Spacer()
        }
        .padding(EdgeInsets(top: 4, leading: 20, bottom: 12, trailing: 20))
        .frame(height: 52)
        .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
        .tabShadow()
    }
}
