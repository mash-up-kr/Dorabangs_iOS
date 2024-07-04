//
//  HomeBannerType.swift
//  Home
//
//  Created by 안상희 on 7/5/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation

public enum HomeBannerType: Int {
    case ai = 0
    case notRead = 1
    case onboarding = 2

    var prefix: String {
        switch self {
        case .ai:
            return "AI로 분류한 링크가"
        case .notRead:
            return "아직 읽지 않은 링크가"
        case .onboarding:
            return "3초만에 링크를\n저장하는 방법이에요"
        }
    }

    var buttonTitle: String {
        switch self {
        case .ai, .notRead:
            return "확인하기"
        case .onboarding:
            return "설정하기"
        }
    }
}
