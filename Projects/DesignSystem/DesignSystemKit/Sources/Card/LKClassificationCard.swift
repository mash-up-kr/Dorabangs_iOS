//
//  LKClassificationCard.swift
//  DesignSystemKit
//
//  Created by 안상희 on 6/28/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import LocalizationKit
import SwiftUI

public struct LKClassificationCard<Thumbnail: View>: View {
    private let title: String?
    private let description: String?
    private let thumbnailImage: () -> Thumbnail
    private let tags: [String]
    private let category: String?
    private let timeSince: String?
    private let buttonTitle: String
    private let deleteAction: () -> Void
    private let moveToFolderAction: () -> Void

    public init(
        title: String?,
        description: String?,
        thumbnailImage: @escaping () -> Thumbnail,
        tags: [String],
        category: String?,
        timeSince: String?,
        buttonTitle: String,
        deleteAction: @escaping () -> Void,
        moveToFolderAction: @escaping () -> Void
    ) {
        self.title = title
        self.description = description
        self.thumbnailImage = thumbnailImage
        self.tags = tags
        self.category = category
        self.timeSince = timeSince
        self.buttonTitle = buttonTitle
        self.deleteAction = deleteAction
        self.moveToFolderAction = moveToFolderAction
    }

    public var body: some View {
        VStack(spacing: 12) {
            closeButton

            HStack(spacing: 16) {
                content
                thumbnail
            }

            tag

            categoryAndTimeSince

            moveToFolderButton
        }
        .padding(20)
        .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
    }

    var closeButton: some View {
        HStack(spacing: 0) {
            Spacer()

            Button(action: deleteAction) {
                Image(.icCloseCircle)
                    .font(weight: .medium, semantic: .caption1)
                    .foregroundStyle(DesignSystemKitAsset.Colors.g4.swiftUIColor)
            }
            .frame(width: 24, height: 24)
        }
    }

    var content: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title ?? "")
                .font(weight: .bold, semantic: .caption3)
                .lineLimit(2)

            HStack(spacing: 2) {
                Image(.icAi)
                    .frame(width: 14, height: 14)

                Text(LocalizationKitStrings.DesignsSystemKit.summary)
                    .font(weight: .medium, semantic: .xs)
                    .foregroundStyle(DesignSystemKitAsset.Colors.g7.swiftUIColor)

                Spacer()
            }

            Text(description ?? "")
                .font(weight: .regular, semantic: .s)
                .foregroundStyle(DesignSystemKitAsset.Colors.g6.swiftUIColor)
                .lineLimit(3)
        }
    }

    var thumbnail: some View {
        VStack(spacing: 0) {
            thumbnailImage()
                .frame(width: 80, height: 80)
                .cornerRadius(4, corners: .allCorners)

            Spacer()
        }
    }

    var tag: some View {
        HStack(spacing: 12) {
            ForEach(tags, id: \.self) { tag in
                LKTag(tag)
            }

            Spacer()
        }
        .frame(height: 26)
    }

    var categoryAndTimeSince: some View {
        HStack(spacing: 8) {
            Text(category ?? "")
                .font(weight: .regular, semantic: .xs)
                .foregroundStyle(DesignSystemKitAsset.Colors.g6.swiftUIColor)

            Text(timeSince ?? "")
                .font(weight: .regular, semantic: .xs)
                .foregroundStyle(DesignSystemKitAsset.Colors.g4.swiftUIColor)

            Spacer()
        }
    }

    var moveToFolderButton: some View {
        Button(action: moveToFolderAction) {
            Text(buttonTitle)
                .font(weight: .medium, semantic: .caption1)
                .foregroundStyle(DesignSystemKitAsset.Colors.primary500.swiftUIColor)
                .padding(.vertical, 7)
                .frame(maxWidth: .infinity)
                .background(DesignSystemKitAsset.Colors.primary100.swiftUIColor)
                .cornerRadius(99, corners: .allCorners)
        }
    }
}
