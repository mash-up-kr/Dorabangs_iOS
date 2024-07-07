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
                FeedHeaderView(folderName: "감자모음집", linkCount: 20)

                ScrollView {
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
                            FeedHeaderTabView()
                        }
                    }
                }
            }
        }
        .onAppear { store.send(.onAppear) }
    }
}

public struct FeedHeaderView: View {
    var folderName: String = ""
    var linkCount: Int = 0

    public init(folderName: String, linkCount: Int) {
        self.folderName = folderName
        self.linkCount = linkCount
    }

    public var body: some View {
        HStack(alignment: .center) {
            Image("")
                .resizable()
                .frame(width: 52, height: 52)
                .scaledToFill()
                .background(DesignSystemKitAsset.Colors.g1.swiftUIColor)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .padding(.leading, 20)
                .padding(.trailing, 16)

            VStack(alignment: .leading, spacing: 0) {
                Text(folderName)
                    .font(weight: .bold, semantic: .base2)
                    .foregroundStyle(DesignSystemKitAsset.Colors.g9.swiftUIColor)
                    .frame(height: 24)
                Text("\(linkCount) 게시물")
                    .font(weight: .medium, semantic: .caption1)
                    .foregroundStyle(DesignSystemKitAsset.Colors.g8.swiftUIColor)
                    .frame(height: 22)
            }
            .frame(height: 48)

            Spacer()
        }
        .frame(height: 64)
    }
}

public struct FeedHeaderTabView: View {
    public var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 0) {
                FeedHeaderTabItemView(title: "전체", isSelected: true)
                    .frame(width: 70)
                Divider()
                    .foregroundStyle(DesignSystemKitAsset.Colors.g2.swiftUIColor)
                    .frame(width: 1, height: 12)
                FeedHeaderTabItemView(title: "읽지 않은", isSelected: true)
                    .frame(width: 98)

                Spacer()
            }

            Divider()
                .background(DesignSystemKitAsset.Colors.g2.swiftUIColor)
                .frame(height: 1)
        }
        .frame(height: 48)
        .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
    }
}

public struct FeedHeaderTabItemView: View {
    let title: String
    var isSelected: Bool

    public init(title: String, isSelected: Bool) {
        self.title = title
        self.isSelected = isSelected
    }

    public var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(title)
                .font(weight: .medium, semantic: .caption2)
                .foregroundStyle(DesignSystemKitAsset.Colors.g9.swiftUIColor)
                .frame(height: 22)

            Circle()
                .frame(width: 3, height: 3)
                .background(DesignSystemKitAsset.Colors.g9.swiftUIColor)
        }
        .frame(height: 30)
    }
}
