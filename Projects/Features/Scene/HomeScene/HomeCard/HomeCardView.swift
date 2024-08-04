//
//  HomeCardView.swift
//  Home
//
//  Created by 안상희 on 7/14/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystemKit
import Kingfisher
import Models
import SwiftUI

struct HomeCardView: View {
    let store: StoreOf<HomeCard>

    enum Constant {
        static let LKTopLogoBarHeight: CGFloat = 48
        static let LKTopScrollViewHeight: CGFloat = 56
    }

    @Dependency(\.folderClient) var folderClient

    var body: some View {
        WithPerceptionTracking {
            Group {
                if store.cards.isEmpty {
                    HomeCardEmptyView()
                } else {
                    contentScrollView()
                }
            }
            .onAppear {
                store.send(.onAppear)
            }
        }
    }

    @ViewBuilder
    private func contentScrollView() -> some View {
        LazyVStack(spacing: 0) {
            ForEach(Array(store.cards.enumerated()), id: \.offset) { index, item in
                LKCard(
                    aiStatus: getStatus(item.aiStatus ?? .failure),
                    progress: 0.4,
                    title: item.title,
                    description: item.description,
                    thumbnailImage: { ThumbnailImage(urlString: item.thumbnail) },
                    tags: Array((item.keywords ?? []).prefix(3).map(\.name)),
                    category: folderClient.getFolderName(folderId: item.folderId) ?? "",
                    timeSince: item.createdAt.timeAgo(),
                    isFavorite: item.isFavorite ?? false,
                    bookMarkAction: { store.send(.bookMarkButtonTapped(postId: item.id, isFavorite: !(item.isFavorite ?? true))) },
                    showModalAction: { store.send(.showModalButtonTapped(postId: item.id, folderId: item.folderId), animation: .easeInOut) }
                )
                .onTapGesture {
                    store.send(.cardTapped(item: item))
                }
                .onAppear {
                    if index != 0, index % 9 == 0, !store.fetchedAllCards {
                        store.send(.updatePage)
                    }
                }
            }
        }
    }

    private func getStatus(_ aiStatus: AIStatus) -> LKCardAIStatus {
        switch aiStatus {
        case .success:
            .success
        case .failure:
            .failure
        case .inProgress:
            .inProgress
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
