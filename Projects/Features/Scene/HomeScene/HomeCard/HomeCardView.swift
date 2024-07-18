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
import Models
import SwiftUI

struct HomeCardView: View {
    let store: StoreOf<HomeCard>

    enum Constant {
        static let LKTopLogoBarHeight: CGFloat = 48
        static let LKTopScrollViewHeight: CGFloat = 56
    }

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
                            isSummarizing: item.keywords != nil,
                            progress: 0.4,
                            title: item.title,
                            description: item.description,
                            tags: item.keywords?.map { $0.name } ?? [],
                            category: item.category,
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
}
