//
//  AIClassificationCardSectionItemView.swift
//  AIClassification
//
//  Created by 김영균 on 7/9/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import Models
import SwiftUI

struct AIClassificationCardSectionItemView: View {
    let section: Folder
    let items: [Card]
    let deleteAction: (Folder, Card) -> Void
    let moveToFolderAction: (Folder, Card) -> Void

    var body: some View {
        LazyVStack(spacing: 0) {
            ForEach(items, id: \.self) { item in
                LKClassificationCard(
                    title: item.title,
                    description: item.description,
                    tags: item.keywords.map(\.name),
                    category: "Category",
                    timeSince: "1일 전",
                    buttonTitle: "\(section.name)(으)로 옮기기",
                    deleteAction: { deleteAction(section, item) },
                    moveToFolderAction: { moveToFolderAction(section, item) }
                )

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
