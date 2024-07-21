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
                    category: section.name,
                    timeSince: item.createdAt.timeAgo(),
                    buttonTitle: "\(section.name)(으)로 옮기기",
                    deleteAction: { deleteAction(section, item) },
                    moveToFolderAction: { moveToFolderAction(section, item) }
                )
                .onAppear {
                    fetchNextPageIfPossible(item)
                }

                if item != items.last {
                    Divider()
                        .background(DesignSystemKitAsset.Colors.g3.swiftUIColor)
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
                .placeholder {
                    DesignSystemKitAsset.Colors.g2.swiftUIColor
                }
                .roundCorner(radius: .point(4), roundingCorners: .all)
                .resizable()
                .frame(width: 80, height: 80)
        } else {
            DesignSystemKitAsset.Colors.g2.swiftUIColor
        }
    }
}
