//
//  LKCard.swift
//  DesignSystemKit
//
//  Created by 안상희 on 6/26/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import LocalizationKit
import Lottie
import SwiftUI

public enum LKCardAIStatus {
    case success
    case inProgress
    case failure
}

public struct LKCard<Thumbnail: View>: View {
    public var aiStatus: LKCardAIStatus = .inProgress
    public var progress: CGFloat = 0.3
    private let title: String?
    private let description: String?
    private let thumbnailImage: () -> Thumbnail
    private let tags: [String]
    private let category: String
    private let timeSince: String
    private let isFavorite: Bool
    private let bookMarkAction: () -> Void
    private let showModalAction: () -> Void

    public init(
        aiStatus: LKCardAIStatus = .inProgress,
        progress: CGFloat,
        title: String?,
        description: String?,
        thumbnailImage: @escaping () -> Thumbnail,
        tags: [String],
        category: String,
        timeSince: String,
        isFavorite: Bool,
        bookMarkAction: @escaping () -> Void,
        showModalAction: @escaping () -> Void
    ) {
        self.aiStatus = aiStatus
        self.progress = progress
        self.title = title
        self.description = description
        self.thumbnailImage = thumbnailImage
        self.tags = tags
        self.category = category
        self.timeSince = timeSince
        self.isFavorite = isFavorite
        self.bookMarkAction = bookMarkAction
        self.showModalAction = showModalAction
    }

    public var body: some View {
        VStack(spacing: 0) {
            HeaderView(
                title: title,
                aiStatus: aiStatus,
                description: description,
                thumbnail: thumbnailImage
            )

            if aiStatus == .success {
                TagsView(tags: tags)
            }

            FooterView(
                category: category,
                timeSince: timeSince,
                aiStatus: aiStatus,
                isFavorite: isFavorite,
                bookMarkAction: bookMarkAction,
                showModalAction: showModalAction
            )
        }
        .padding(20)
        .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
    }
}

private struct HeaderView<Thumbnail: View>: View {
    let title: String?
    let aiStatus: LKCardAIStatus
    let description: String?
    let thumbnail: () -> Thumbnail

    var body: some View {
        HStack(alignment: .top, spacing: 24) {
            VStack(alignment: .leading, spacing: 10) {
                Text(title ?? "")
                    .font(weight: .bold, semantic: .caption3)
                    .foregroundStyle(DesignSystemKitAsset.Colors.g9.swiftUIColor)
                    .lineLimit(2)

                switch aiStatus {
                case .success:
                    MajorContentView(description: description)
                case .inProgress:
                    SummarizingView()
                case .failure:
                    EmptyView()
                }
            }

            CardThumbnailView(thumbnail: thumbnail)
        }
    }
}

private struct MajorContentView: View {
    let description: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 2) {
                Image(.icAi)
                    .frame(width: 14, height: 14)

                Text(LocalizationKitStrings.DesignsSystemKit.summary)
                    .font(weight: .medium, semantic: .xs)
                    .foregroundStyle(DesignSystemKitAsset.Colors.g7.swiftUIColor)

                Spacer()
            }
            .frame(height: 14)

            Text(description ?? "")
                .font(weight: .regular, semantic: .s)
                .foregroundStyle(DesignSystemKitAsset.Colors.g6.swiftUIColor)
                .lineLimit(3)
        }
    }
}

private struct CardThumbnailView<Thumbnail: View>: View {
    let thumbnail: () -> Thumbnail

    var body: some View {
        VStack(spacing: 0) {
            thumbnail()
                .frame(width: 80, height: 80)
                .cornerRadius(4, corners: .allCorners)

            Spacer()
        }
    }
}

private struct TagsView: View {
    let tags: [String]

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 12)

            HStack(spacing: 12) {
                ForEach(tags, id: \.self) { tag in
                    LKTag(tag)
                }
                Spacer()
            }.frame(height: 26)
        }
    }
}

private struct FooterView: View {
    let category: String
    let timeSince: String
    let aiStatus: LKCardAIStatus
    let isFavorite: Bool
    let bookMarkAction: () -> Void
    let showModalAction: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 12)

            HStack(spacing: 0) {
                CategoryInfoView(
                    category: category,
                    timeSince: timeSince
                )

                Spacer()

                if aiStatus == .success {
                    ActionButtons(
                        isFavorite: isFavorite,
                        bookMarkAction: bookMarkAction,
                        showModalAction: showModalAction
                    )
                }
            }
        }
    }
}

private struct CategoryInfoView: View {
    let category: String
    let timeSince: String

    var body: some View {
        HStack(spacing: 8) {
            Text(category)
                .font(weight: .regular, semantic: .xs)
                .foregroundStyle(DesignSystemKitAsset.Colors.g6.swiftUIColor)

            Text(timeSince)
                .font(weight: .regular, semantic: .xs)
                .foregroundStyle(DesignSystemKitAsset.Colors.g4.swiftUIColor)
        }
    }
}

private struct ActionButtons: View {
    let isFavorite: Bool
    let bookMarkAction: () -> Void
    let showModalAction: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: bookMarkAction) {
                Image(isFavorite ? .icBookmarkActive : .icBookmarkDefault)
                    .frame(width: 24, height: 24)
            }

            Button(action: showModalAction) {
                Image(.icMoreGray)
                    .frame(width: 24, height: 24)
            }
        }
    }
}

private struct SummarizingView: View {
    private let bundle = Bundle(identifier: "com.mashup.dorabangs.designSystemKit")

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 2) {
                Image(.icAi)
                    .frame(width: 14, height: 14)

                Text(LocalizationKitStrings.DesignsSystemKit.summarizing)
                    .font(weight: .medium, semantic: .xs)
                    .foregroundStyle(DesignSystemKitAsset.Colors.g7.swiftUIColor)

                Spacer()
            }
            .frame(height: 14)

            Spacer()
                .frame(height: 10)

            HStack(spacing: 0) {
                LottieView(
                    animation: .named(
                        JSONFiles.Skeleton.jsonName,
                        bundle: bundle ?? .main
                    )
                )
                .playing(loopMode: .loop)
                .frame(height: 100)

                Spacer()
            }
        }
    }
}

#Preview {
    LKCard<ThumbnailView>(
        aiStatus: .inProgress,
        progress: 0.3,
        title: "에스파 '슈퍼노바', 올해 멜론 주간 차트 최장 1위…'쇠맛' 흥행 질주에스파 '슈퍼노바', 올해 멜론 주간 차트 최장 1위…'쇠맛' 흥행 질주 에스파 '슈퍼노바', 올해 멜론 주간 차트 최장 1위…'쇠맛' 흥행 질주",
        description: "사건은 다가와 아 오 에 거세게 커져가 아 오 에 That tick, that tick, tick bomb That tick, that tick, tick bomb 사건은 다가와 아 오 에 거세게 커져가 아 오 에 That tick, that tick, tick bomb That tick, that tick, tick bomb",
        thumbnailImage: { ThumbnailView() },
        tags: ["에스파", "SM", "오에이옹에이옹"],
        category: "Category",
        timeSince: "1일 전",
        isFavorite: true,
        bookMarkAction: {},
        showModalAction: {}
    )
}
