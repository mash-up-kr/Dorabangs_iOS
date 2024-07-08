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
                            VStack(spacing: 0) {
                                FeedHeaderTabView(select: { selectType in
                                    switch selectType {
                                    case .all:
                                        store.send(.tapAllType)
                                    case .unread:
                                        store.send(.tapUnreadType)
                                    }
                                })
                                FeedSortView(onSort: { sortType in
                                    switch sortType {
                                    case .latest:
                                        store.send(.tapSortLatest)
                                    case .past:
                                        store.send(.tapSortPast)
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

public struct FeedHeaderView: View {
    var folderName: String = ""
    var linkCount: Int = 0

    public init(folderName: String, linkCount: Int) {
        self.folderName = folderName
        self.linkCount = linkCount
    }

    public var body: some View {
        HStack(alignment: .center) {
            DesignSystemKitAsset.Icons.imgAll
                .swiftUIImage
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

public struct FeedSortView: View {
    let onSort: (SortType) -> Void

    @State var selectedType: SortType = .latest

    public enum SortType {
        case latest, past
    }

    public init(onSort: @escaping (SortType) -> Void) {
        self.onSort = onSort
    }

    public var body: some View {
        HStack(alignment: .center, spacing: 16) {
            Spacer()
            FeedSortItem(image: DesignSystemKitAsset.Icons.icBookmark.swiftUIImage, title: "최신순", isSelected: selectedType == .latest, onTap: {
                onSort(.latest)
                selectedType = .latest

            })
            FeedSortItem(image: DesignSystemKitAsset.Icons.icBookmark.swiftUIImage, title: "과거순", isSelected: selectedType == .past, onTap: {
                onSort(.past)
                selectedType = .past
            })
            .padding(.trailing, 20)
        }
        .frame(height: 54)
        .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
    }
}

public struct FeedSortItem: View {
    let image: Image
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    public init(image: Image, title: String, isSelected: Bool, onTap: @escaping () -> Void) {
        self.image = image
        self.title = title
        self.isSelected = isSelected
        self.onTap = onTap
    }

    public var body: some View {
        HStack(alignment: .center, spacing: 4) {
            image
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isSelected ? DesignSystemKitAsset.Colors.g9.swiftUIColor : DesignSystemKitAsset.Colors.g4.swiftUIColor)
                .frame(width: 24, height: 24)

            Text(title)
                .font(weight: .medium, semantic: .caption1)
                .foregroundStyle(isSelected ? DesignSystemKitAsset.Colors.g9.swiftUIColor : DesignSystemKitAsset.Colors.g4.swiftUIColor)
        }
        .frame(height: 22)
        .onTapGesture {
            onTap()
        }
    }
}

public struct FeedHeaderTabView: View {
    public enum FeedViewTypd {
        case all, unread
    }

    let select: (FeedViewTypd) -> Void
    @State var selectedType: FeedViewTypd = .all

    public init(select: @escaping (FeedViewTypd) -> Void) {
        self.select = select
    }

    public var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 0) {
                FeedHeaderTabItemView(title: "전체", isSelected: selectedType == .all, onTap: {
                    select(.all)
                    selectedType = .all
                })
                .frame(width: 70)

                Divider()
                    .foregroundStyle(DesignSystemKitAsset.Colors.g2.swiftUIColor)
                    .frame(width: 1, height: 12)

                FeedHeaderTabItemView(title: "읽지 않은", isSelected: selectedType == .unread, onTap: {
                    select(.unread)
                    selectedType = .unread
                })
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
    var isSelected: Bool = false
    var onTap: () -> Void

    public init(title: String, isSelected: Bool, onTap: @escaping () -> Void) {
        self.title = title
        self.isSelected = isSelected
        self.onTap = onTap
    }

    public var body: some View {
        VStack(alignment: .center, spacing: 4) {
            Text(title)
                .font(weight: .medium, semantic: .caption2)
                .foregroundStyle(isSelected ? DesignSystemKitAsset.Colors.g9.swiftUIColor : DesignSystemKitAsset.Colors.g4.swiftUIColor)
                .frame(height: 22)

            Circle()
                .frame(width: 3, height: 3)
                .background(isSelected ? DesignSystemKitAsset.Colors.g9.swiftUIColor : DesignSystemKitAsset.Colors.g4.swiftUIColor)
        }
        .frame(height: 30)
        .onTapGesture(perform: {
            onTap()
        })
    }
}
