//
//  HomeBannerType.swift
//  Home
//
//  Created by 안상희 on 7/9/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation
import LocalizationKit

public enum HomeBannerType: Int {
    case ai = 0
    case unread = 1
    case onboarding = 2

    var prefix: String {
        switch self {
        case .ai:
            LocalizationKitStrings.HomeScene.aiBannerPrefix
        case .unread:
            LocalizationKitStrings.HomeScene.unreadBannerPrefix
        case .onboarding:
            LocalizationKitStrings.HomeScene.onboaringBannerPrefix
        }
    }

    var buttonTitle: String {
        switch self {
        case .ai, .unread:
            LocalizationKitStrings.HomeScene.aiAndUnreadButtonTitle
        case .onboarding:
            LocalizationKitStrings.HomeScene.onboardingButtonTitle
        }
    }
}

public struct HomeBanner: Hashable {
    public let bannerType: HomeBannerType
    public let prefix: String
    public let buttonTitle: String
    public let count: Int

    public init(
        bannerType: HomeBannerType,
        prefix: String,
        buttonTitle: String,
        count: Int
    ) {
        self.bannerType = bannerType
        self.prefix = prefix
        self.buttonTitle = buttonTitle
        self.count = count
    }
}
