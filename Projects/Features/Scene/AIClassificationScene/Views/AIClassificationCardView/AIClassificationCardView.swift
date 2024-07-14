//
//  AIClassificationCardView.swift
//  AIClassification
//
//  Created by 김영균 on 7/8/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import Models
import SwiftUI

struct AIClassificationCardView: View {
    let store: StoreOf<AIClassificationCard>

    enum Constant {
        static let LKTextMiddleTopBarHeight: CGFloat = 48
        static let AIClassificationTabViewHeight: CGFloat = 56
    }

    var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                if store.sections.isEmpty {
                    emptyView()
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
    private func emptyView() -> some View {
        let selectedTab = store.tabs[store.selectedTabIndex]
        if selectedTab.type == .all {
            AIClassificationCardEmptyView(title: "홈으로 이동") {
                store.send(.routeToHomeScreen)
            }
        } else {
            AIClassificationCardEmptyView(title: "\(selectedTab.name)(으)로 이동") {
                store.send(.routeToFeedScreen(selectedTab))
            }
        }
    }

    @ViewBuilder
    private func contentScrollView() -> some View {
        ScrollView {
            Spacer().frame(height: Constant.LKTextMiddleTopBarHeight + Constant.AIClassificationTabViewHeight)

            LazyVStack(spacing: 0) {
                ForEach(store.sections.keys.elements, id: \.self) { section in
                    VStack(spacing: 0) {
                        AIClassificationCardSectionHeaderView(
                            title: section.name,
                            count: section.postCount,
                            action: { store.send(.moveToAllItemsToFolderButtonTapped(section: section)) }
                        )

                        WithPerceptionTracking {
                            AIClassificationCardSectionItemView(
                                section: section,
                                items: store.sections[section] ?? [],
                                deleteAction: { section, item in
                                    store.send(.deleteButtonTapped(section: section, item: item))
                                },
                                moveToFolderAction: { section, item in
                                    store.send(.moveToFolderButtonTapped(section: section, item: item))
                                }
                            )
                        }
                    }
                }
            }
        }
    }
}
