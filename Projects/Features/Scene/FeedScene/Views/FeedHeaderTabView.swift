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
