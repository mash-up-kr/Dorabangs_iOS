//
//  HomeCardView.swift
//  Home
//
//  Created by 안상희 on 7/14/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

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
//                    Color.pink
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
                ForEach(store.cards.indices, id: \.self) { index in
                    VStack(spacing: 0) {
                        LKCard(
                            isSummarizing: true,
                            progress: 0.3,
                            title: "에스파 '슈퍼노바', 올해 멜론 주간 차트 최장 1위…'쇠맛' 흥행 질주에스파 '슈퍼노바', 올해 멜론 주간 차트 최장 1위…'쇠맛' 흥행 질주 에스파 '슈퍼노바', 올해 멜론 주간 차트 최장 1위…'쇠맛' 흥행 질주",
                            description: "사건은 다가와 아 오 에 거세게 커져가 아 오 에 That tick, that tick, tick bomb That tick, that tick, tick bomb 사건은 다가와 아 오 에 거세게 커져가 아 오 에 That tick, that tick, tick bomb That tick, that tick, tick bomb",
                            tags: ["# 에스파", "# SM", "# 오에이옹에이옹"],
                            category: "Category",
                            timeSince: "1일 전",
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
