//
//  HomeBannerPageControlView.swift
//  DesignSystemKit
//
//  Created by 안상희 on 7/4/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import SwiftUI

public struct HomeBannerPageControlView: View {
    private let bannerList: [HomeBanner]
    private let selectedBanner: HomeBannerType

    public init(bannerList: [HomeBanner], selectedBanner: HomeBannerType) {
        self.bannerList = bannerList
        self.selectedBanner = selectedBanner
    }

    public var body: some View {
        HStack(spacing: 0) {
            HStack(spacing: 6) {
                ForEach(bannerList, id: \.self) { banner in
                    PageControlComponentView(
                        currentBannerType: banner.bannerType,
                        isCurrentIndex: banner.bannerType == selectedBanner
                    )
                }
            }
        }
        .padding(.horizontal, 8)
        .frame(height: 16)
        .background(DesignSystemKitAsset.Colors.gradient1)
        .cornerRadius(50, corners: .allCorners)
    }
}

private struct PageControlComponentView: View {
    private let currentBannerType: HomeBannerType
    private let isCurrentIndex: Bool

    fileprivate init(currentBannerType: HomeBannerType, isCurrentIndex: Bool) {
        self.currentBannerType = currentBannerType
        self.isCurrentIndex = isCurrentIndex
    }

    fileprivate var body: some View {
        if currentBannerType == .ai {
            if isCurrentIndex {
                DesignSystemKitAsset.Icons.icStarFill.swiftUIImage
                    .frame(width: 8, height: 8)
            } else {
                DesignSystemKitAsset.Icons.icStar.swiftUIImage
                    .frame(width: 8, height: 8)
            }
        } else {
            if isCurrentIndex {
                DesignSystemKitAsset.Icons.icDotFill.swiftUIImage
                    .frame(width: 4, height: 4)
            } else {
                DesignSystemKitAsset.Icons.icDot.swiftUIImage
                    .frame(width: 4, height: 4)
            }
        }
    }
}
