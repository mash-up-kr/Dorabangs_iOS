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
            VStack(spacing: 0) {
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
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(Array(store.cards.enumerated()), id: \.offset) { index, item in
                    VStack(spacing: 0) {
                        LKCard(
                            aiStatus: getStatus(item.aiStatus ?? .failure),
                            progress: 0.4,
                            title: item.title,
                            description: item.description,
                            thumbnailImage: { ThumbnailImage(urlString: "") },
                            tags: Array((item.keywords ?? []).prefix(3).map(\.name)),
                            category: folderClient.getFolderName(folderId: item.folderId) ?? "",
                            timeSince: item.createdAt.timeAgo(),
                            bookMarkAction: { store.send(.bookMarkButtonTapped(index)) },
                            showModalAction: { store.send(.showModalButtonTapped(index), animation: .easeInOut) }
                        )
                        .onAppear {
                            if index % 9 == 0 {
                                store.send(.fetchCards)
                            }
                        }
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
