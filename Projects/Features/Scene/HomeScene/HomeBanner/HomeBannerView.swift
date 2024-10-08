//
//  HomeBannerView.swift
//  Home
//
//  Created by 안상희 on 7/5/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import LocalizationKit
import Lottie
import SwiftUI

public struct HomeBannerView: View {
    private let banner: HomeBanner
    private let action: () -> Void
    private let bundle = Bundle(identifier: "com.mashup.dorabangs.designSystemKit")
    @State private var isAnimating = false

    public init(
        banner: HomeBanner,
        action: @escaping () -> Void
    ) {
        self.banner = banner
        self.action = action
    }

    public var body: some View {
        VStack(spacing: 0) {
            LottieView(animation: .named(lotteFileName, bundle: bundle ?? .main))
                .backgroundBehavior(.pauseAndRestore)
                .configure { view in
                    isAnimating ? view.play() : view.stop()
                }
                .onReceive(NotificationCenter.default.publisher(for: .playBannerLottie)) { notification in
                    if let type = notification.userInfo?["type"] as? HomeBannerType {
                        isAnimating = (type == banner.bannerType)
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: .stopBannerLottie)) { _ in
                    isAnimating = false
                }
                .frame(width: 270, height: 210)

            HomeBannerMessageView(
                prefix: banner.prefix,
                count: banner.count
            )
            .frame(height: 56)

            Spacer()
                .frame(height: 12)

            BannerButton(title: banner.buttonTitle, action: action)

            Spacer()
                .frame(height: 24)
        }
        .frame(maxWidth: .infinity)
        .background(DesignSystemKitAsset.Colors.gradient2)
    }

    var lotteFileName: String {
        switch banner.bannerType {
        case .ai:
            JSONFiles.Ai.jsonName
        case .onboarding:
            JSONFiles.Tutorials.jsonName
        case .unread:
            JSONFiles.Unread.jsonName
        }
    }
}

private struct HomeBannerMessageView: View {
    private let prefix: String
    private let count: Int?

    fileprivate init(prefix: String, count: Int?) {
        self.prefix = prefix
        self.count = count
    }

    fileprivate var body: some View {
        VStack(spacing: 0) {
            Text(prefix)
                .multilineTextAlignment(.center)
                .font(weight: .heavy, semantic: .subtitle2)
                .foregroundStyle(DesignSystemKitAsset.Colors.g8.swiftUIColor)

            if let count, count > 0 {
                HStack(spacing: 0) {
                    Text(LocalizationKitStrings.HomeScene.linkCount(count))
                        .font(weight: .heavy, semantic: .subtitle2)
                        .foregroundStyle(DesignSystemKitAsset.Colors.g8.swiftUIColor)

                    Text(LocalizationKitStrings.HomeScene.available)
                        .font(weight: .heavy, semantic: .subtitle2)
                        .foregroundStyle(DesignSystemKitAsset.Colors.g8.swiftUIColor)
                }
            }
        }
    }
}
