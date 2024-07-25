//
//  HomeBannerView.swift
//  Home
//
//  Created by 안상희 on 7/5/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import Lottie
import SwiftUI

public struct HomeBannerView: View {
    private let banner: HomeBanner
    private let action: () -> Void
    private let bundle = Bundle(identifier: "com.mashup.dorabangs.designSystemKit")

    public init(
        banner: HomeBanner,
        action: @escaping () -> Void
    ) {
        self.banner = banner
        self.action = action
    }

    public var body: some View {
        VStack(spacing: 0) {
            LottieView(
                animation: .named(
                    banner.bannerType == .ai ? JSONFiles.Ai.jsonName : JSONFiles.Unread.jsonName,
                    bundle: bundle ?? .main
                )
            )
            .playing(loopMode: .playOnce)
            .frame(width: 250, height: 212)

            HomeBannerMessageView(
                prefix: banner.prefix,
                count: banner.count
            )

            Spacer()
                .frame(height: 12)

            BannerButton(title: banner.buttonTitle, action: action)

            Spacer()
                .frame(height: 24)
        }
        .frame(width: 390, height: 340)
        .background(DesignSystemKitAsset.Colors.gradient6)
        .background(.white.opacity(0.5))
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
                    Text("\(count)개 ")
                        .font(weight: .heavy, semantic: .subtitle2)
                        .foregroundStyle(DesignSystemKitAsset.Colors.primary.swiftUIColor)

                    Text("있어요")
                        .font(weight: .heavy, semantic: .subtitle2)
                        .foregroundStyle(DesignSystemKitAsset.Colors.g8.swiftUIColor)
                }
            }
        }
    }
}
