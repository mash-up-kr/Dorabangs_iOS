//
//  LKCard.swift
//  DesignSystemKit
//
//  Created by 안상희 on 6/26/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

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
        self.bookMarkAction = bookMarkAction
        self.showModalAction = showModalAction
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 13) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(title ?? "")
                        .font(weight: .bold, semantic: .caption3)
                        .lineLimit(2)

                    if aiStatus == .inProgress {
                        SummarizingView()
                    } else {
                        HStack(spacing: 4) {
                            Image(.icStar)
                                .frame(width: 14, height: 14)

                            // TODO: Constants로 변경~
                            Text("주요 내용")
                                .font(weight: .medium, semantic: .xs)
                                .foregroundStyle(DesignSystemKitAsset.Colors.g7.swiftUIColor)

                            Spacer()
                        }

                        Text(description ?? "")
                            .font(weight: .regular, semantic: .caption1)
                            .foregroundStyle(DesignSystemKitAsset.Colors.g6.swiftUIColor)
                            .lineLimit(3)
                    }
                }

                VStack(spacing: 0) {
                    thumbnail
                }
            }

            if aiStatus == .inProgress {
                Spacer()
                    .frame(height: 16)

                LKCardProgressBar(progress: progress)
                    .frame(height: 4)
            } else if aiStatus == .success {
                Spacer()
                    .frame(height: 12)

                HStack(spacing: 12) {
                    ForEach(tags, id: \.self) { tag in
                        LKTag(tag)
                    }

                    Spacer()
                }
                .frame(height: 24)
            }

            Spacer()
                .frame(height: 12)

            HStack {
                HStack(spacing: 8) {
                    Text(category)
                        .font(weight: .regular, semantic: .xs)
                        .foregroundStyle(DesignSystemKitAsset.Colors.g5.swiftUIColor)

                    Image(.icEclipse)
                        .frame(width: 2, height: 2)

                    Text(timeSince)
                        .font(weight: .regular, semantic: .xs)
                        .foregroundStyle(DesignSystemKitAsset.Colors.g5.swiftUIColor)

                    Spacer()
                }

                Spacer()

                HStack(spacing: 12) {
                    Button(action: bookMarkAction) {
                        Image(.icBookmarkDefault)
                            .frame(width: 24, height: 24)
                    }

                    Button(action: showModalAction) {
                        Image(.icMoreGray)
                            .frame(width: 24, height: 24)
                    }
                }
            }
        }
        .padding(20)
        .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
    }

    private var thumbnail: some View {
        VStack(spacing: 0) {
            thumbnailImage()
                .frame(width: 80, height: 80)
                .cornerRadius(4, corners: .allCorners)

            Spacer()
        }
    }
}

private struct SummarizingView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 4) {
                Image(.icStar)
                    .frame(width: 14, height: 14)

                Text("요약 중")
                    .font(weight: .medium, semantic: .xs)
                    .foregroundStyle(DesignSystemKitAsset.Colors.g7.swiftUIColor)

                Spacer()
            }
            .frame(height: 14)

            Spacer()
                .frame(height: 12)

            HStack(spacing: 0) {
                LKDescriptionSkeletonView()
                    .frame(width: 254, height: 56)

                Spacer()
            }

            Spacer()
                .frame(height: 8)

            LKKeywordSkeletonView()
                .frame(width: 172, height: 26)
        }
    }
}

private struct CategorySummarizingView: View {
    var body: some View {
        HStack(spacing: 0) {}
            .padding(.trailing, 5)
    }
}

#Preview {
    LKCard<ThumbnailView>(
        aiStatus: .success,
        progress: 0.3,
        title: "에스파 '슈퍼노바', 올해 멜론 주간 차트 최장 1위…'쇠맛' 흥행 질주에스파 '슈퍼노바', 올해 멜론 주간 차트 최장 1위…'쇠맛' 흥행 질주 에스파 '슈퍼노바', 올해 멜론 주간 차트 최장 1위…'쇠맛' 흥행 질주",
        description: "사건은 다가와 아 오 에 거세게 커져가 아 오 에 That tick, that tick, tick bomb That tick, that tick, tick bomb 사건은 다가와 아 오 에 거세게 커져가 아 오 에 That tick, that tick, tick bomb That tick, that tick, tick bomb",
        thumbnailImage: { ThumbnailView() },
        tags: ["에스파", "SM", "오에이옹에이옹"],
        category: "Category",
        timeSince: "1일 전",
        bookMarkAction: {},
        showModalAction: {}
    )
}
