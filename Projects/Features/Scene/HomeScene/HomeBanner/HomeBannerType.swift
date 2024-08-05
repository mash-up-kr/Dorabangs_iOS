//
//  HomeBannerType.swift
//  Home
//
//  Created by 안상희 on 7/9/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation

public enum HomeBannerType: Int {
    case ai = 0
    case unread = 1
    case onboarding = 2

    var prefix: String {
        switch self {
        case .ai:
            "AI로 분류한 링크가"
        case .unread:
            "아직 읽지 않은 링크가"
        case .onboarding:
            "3초만에 링크를\n저장하는 방법이에요"
        }
    }

    var buttonTitle: String {
        switch self {
        case .ai, .unread:
            "확인하기"
        case .onboarding:
            "설정하기"
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
