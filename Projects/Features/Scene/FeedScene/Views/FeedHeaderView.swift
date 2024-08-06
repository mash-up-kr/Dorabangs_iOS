//
//  FeedHeaderView.swift
//  Feed
//
//  Created by 박소현 on 7/8/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import LocalizationKit
import SwiftUI

public struct FeedHeaderView: View {
    var folderName: String = ""
    var linkCount: Int = 0

    public init(folderName: String, linkCount: Int) {
        self.folderName = folderName
        self.linkCount = linkCount
    }

    public var body: some View {
        HStack(alignment: .center) {
            DesignSystemKitAsset.Images.imgAllBig.swiftUIImage
                .frame(width: 52, height: 52)
                .scaledToFill()
                .background(DesignSystemKitAsset.Colors.g1.swiftUIColor)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.leading, 20)
                .padding(.trailing, 16)

            VStack(alignment: .leading, spacing: 0) {
                Text(folderName)
                    .font(weight: .bold, semantic: .base2)
                    .foregroundStyle(DesignSystemKitAsset.Colors.g9.swiftUIColor)
                    .frame(height: 24)
                Text(LocalizationKitStrings.FeedScene.postCounts(linkCount))
                    .font(weight: .medium, semantic: .caption1)
                    .foregroundStyle(DesignSystemKitAsset.Colors.g8.swiftUIColor)
                    .frame(height: 22)
            }
            .frame(height: 48)

            Spacer()
        }
        .frame(height: 64)
    }
}
