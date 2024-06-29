//
//  HomeView.swift
//  Home
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import SwiftUI

public struct HomeView: View {
    private let store: StoreOf<Home>

    public init(store: StoreOf<Home>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                LKTopLogoBar {
                    store.send(.addLinkButtonTapped)
                }

                ScrollView {
                    Color.pink
                        .frame(height: 306)

                    LazyVStack(pinnedViews: .sectionHeaders) {
                        Section {
                            LazyVStack(spacing: 0) {
                                ForEach(store.cards.indices, id: \.self) { index in
                                    LKCard(
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
                            HorizontalScrollView()
                        }
                    }
                }
            }
            .padding(.vertical, 12)
        }
    }
}
