//
//  AIClassificationCardSectionItemView.swift
//  AIClassification
//
//  Created by 김영균 on 7/9/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Common
import DesignSystemKit
import Kingfisher
import LocalizationKit
import Models
import SwiftUI

struct AIClassificationCardSectionItemView: View {
    let section: Folder
    let items: [Card]
    let deleteAction: (Folder, Card) -> Void
    let moveToFolderAction: (Folder, Card) -> Void
    let fetchNextPageIfPossible: (_ item: Card) -> Void

    var body: some View {
        ForEach(items, id: \.self) { item in
            VStack(spacing: 0) {
                LKClassificationCard(
                    title: item.title,
                    description: item.description,
                    thumbnailImage: { ThumbnailImage(urlString: item.thumbnail) },
                    tags: Array((item.keywords ?? []).prefix(3).map(\.name)),
                    category: LocalizationKitStrings.Common.readLaterLink,
                    timeSince: item.createdAt.timeAgo(),
                    buttonTitle: LocalizationKitStrings.AIClassificationScene.moveToFolderButtonTitle(section.name),
                    deleteAction: { deleteAction(section, item) },
                    moveToFolderAction: { moveToFolderAction(section, item) }
                )
                .onAppear {
                    fetchNextPageIfPossible(item)
                }

                if item != items.last {
                    LKDivider()
                        .padding(.vertical, 12)
                        .padding(.horizontal, 20)
                }
            }
        }
    }
}

struct ThumbnailImage: View {
    let urlString: String?

    var body: some View {
        if let urlString, let url = URL(string: urlString) {
            KFImage(url)
                .placeholder { DesignSystemKitAsset.Images.imgThumbnail.swiftUIImage }
                .appendProcessor(DownsamplingImageProcessor(size: .init(width: 80, height: 80)))
                .scaleFactor(UIScreen.main.scale)
                .cacheOriginalImage()
                .roundCorner(radius: .point(4), roundingCorners: .all)
                .cancelOnDisappear(true)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
        } else {
            DesignSystemKitAsset.Images.imgThumbnail.swiftUIImage
                .resizable()
                .frame(width: 80, height: 80)
                .cornerRadius(4, corners: .allCorners)
        }
    }
}
