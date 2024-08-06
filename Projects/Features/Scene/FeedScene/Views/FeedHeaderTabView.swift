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

public struct FeedHeaderTabView: View {
    public enum FeedViewTypd {
        case all, unread
    }

    let select: (FeedViewTypd) -> Void
    @State var selectedType: FeedViewTypd = .all

    public init(select: @escaping (FeedViewTypd) -> Void) {
        self.select = select
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            HStack(alignment: .center, spacing: 0) {
                FeedHeaderTabItemView(title: LocalizationKitStrings.Common.all, isSelected: selectedType == .all, onTap: {
                    select(.all)
                    selectedType = .all
                })
                .frame(width: 70)

                Divider()
                    .foregroundStyle(DesignSystemKitAsset.Colors.g2.swiftUIColor)
                    .frame(width: 1, height: 12)

                FeedHeaderTabItemView(title: LocalizationKitStrings.FeedScene.unreadTab, isSelected: selectedType == .unread, onTap: {
                    select(.unread)
                    selectedType = .unread
                })
                .frame(width: 98)

                Spacer()
            }
            .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
            .frame(height: 48)

            Divider()
                .background(DesignSystemKitAsset.Colors.g2.swiftUIColor)
                .frame(height: 1)
        }
        .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
        .frame(height: 48)
    }
}
