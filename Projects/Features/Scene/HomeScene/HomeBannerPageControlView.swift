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
        .background(gradientBackground)
        .cornerRadius(50, corners: .allCorners)
    }

    private var gradientBackground: AngularGradient {
        AngularGradient(
            gradient: Gradient(stops: [
                .init(color: Color(red: 0.9, green: 0.93, blue: 1).opacity(0.1), location: 0.05),
                .init(color: Color(red: 0.47, green: 0.78, blue: 1).opacity(0.1), location: 0.25),
                .init(color: Color(red: 0.67, green: 0.74, blue: 1).opacity(0.1), location: 0.50),
                .init(color: Color(red: 0.84, green: 0.59, blue: 1).opacity(0.1), location: 0.75),
                .init(color: Color(red: 0.65, green: 0.6, blue: 1).opacity(0.1), location: 1.00)
            ]),
            center: .center,
            angle: .degrees(45)
        )
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
