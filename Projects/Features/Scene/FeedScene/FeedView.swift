//
//  FeedView.swift
//  Feed
//
//  Created by 박소현 on 6/29/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import SwiftUI

public struct FeedView: View {
    private let store: StoreOf<Feed>

    public init(store: StoreOf<Feed>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            VStack {
                LKTextMiddleTopBar(
                    title: "감자모음집",
                    backButtonAction: { store.send(.backButtonTapped) },
                    rightButtomImage: DesignSystemKitAsset.Icons.icMore.swiftUIImage,
                    rightButtonEnabled: true,
                    action: {
                        store.send(.tapMore)
                    }
                )

                ScrollView {
                    LazyVStack(pinnedViews: .sectionHeaders) {
                        FeedHeaderView(folderName: "감자모음집", linkCount: 20)

                        Section {
                            LazyVStack(spacing: 0) {
                                FeedSortView(onSort: { sortType in
                                    switch sortType {
                                    case .latest:
                                        store.send(.tapSortLatest)
                                    case .past:
                                        store.send(.tapSortPast)
                                    }
                                })

                                ForEach(store.cards.indices, id: \.self) { index in
                                    LKCard(
                                        isSummarizing: true,
                                        progress: 1.0,
                                        title: "에스파 '슈퍼노바', 올해 멜론 주간 차트 최장 1위…'쇠맛' 흥행 질주에스파 '슈퍼노바', 올해 멜론 주간 차트 최장 1위…'쇠맛' 흥행 질주 에스파 '슈퍼노바', 올해 멜론 주간 차트 최장 1위…'쇠맛' 흥행 질주",
                                        description: "사건은 다가와 아 오 에 거세게 커져가 아 오 에 That tick, that tick, tick bomb That tick, that tick, tick bomb 사건은 다가와 아 오 에 거세게 커져가 아 오 에 That tick, that tick, tick bomb That tick, that tick, tick bomb",
                                        tags: ["# 에스파", "# SM", "# 오에이옹에이옹"],
                                        category: "Category",
                                        timeSince: "1일 전",
                                        bookMarkAction: { store.send(.bookMarkButtonTapped(index)) },
                                        showModalAction: { store.send(.showModalButtonTapped(index)) }
                                    )
                                    .onAppear {
                                        if index % 9 == 0 {
                                            store.send(.fetchData)
                                        }
                                    }
                                }
                            }
                        } header: {
                            VStack(spacing: 0) {
                                FeedHeaderTabView(select: { selectType in
                                    switch selectType {
                                    case .all:
                                        store.send(.tapAllType)
                                    case .unread:
                                        store.send(.tapUnreadType)
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }
        .onAppear { store.send(.onAppear) }
    }
}
