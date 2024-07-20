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
                if store.items.isEmpty {
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
        if store.selectedFolderId == Folder.ID.all {
            AIClassificationCardEmptyView(title: "홈으로 이동") {
                store.send(.routeToHomeScreen)
            }
        } else if let selectedSection = store.sections[store.selectedFolderId] {
            AIClassificationCardEmptyView(title: "\(selectedSection.name)(으)로 이동") {
                store.send(.routeToFeedScreen(selectedSection))
            }
        }
    }

    @ViewBuilder
    private func contentScrollView() -> some View {
        List {
            Spacer()
                .frame(height: Constant.LKTextMiddleTopBarHeight + Constant.AIClassificationTabViewHeight)
                .buttonStyle(.plain)
                .listRowInsets(.init())
                .listRowSeparator(.hidden)

            ForEach(store.items.keys.elements, id: \.self) { folderId in
                if let section = store.sections[folderId], let items = store.items[folderId] {
                    AIClassificationCardSectionHeaderView(
                        title: section.name,
                        count: section.postCount,
                        action: { store.send(.moveToAllItemsToFolderButtonTapped(section: section)) }
                    )

                    AIClassificationCardSectionItemView(
                        section: section,
                        items: items,
                        deleteAction: { section, item in
                            store.send(.deleteButtonTapped(section: section, item: item))
                        },
                        moveToFolderAction: { section, item in
                            store.send(.moveToFolderButtonTapped(section: section, item: item))
                        },
                        fetchNextPageIfPossible: { item in
                            store.send(.fetchNextPageIfPossible(item: item))
                        }
                    )
                }
            }
            .buttonStyle(.plain)
            .listRowInsets(.init())
            .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}
