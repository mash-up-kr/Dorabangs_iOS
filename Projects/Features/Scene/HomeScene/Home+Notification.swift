//
//  Home+Notification.swift
//  Home
//
//  Created by 김영균 on 8/4/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let playBannerLottie = Notification.Name("playBannerLottie")
    static let stopBannerLottie = Notification.Name("stopBannerLottie")
}

extension HomeBannerCarousel {
    func playBannerLottie(with type: HomeBannerType) {
        NotificationCenter.default.post(name: .playBannerLottie, object: nil, userInfo: ["type": type])
    }

    func stopBannerLottie() {
        NotificationCenter.default.post(name: .stopBannerLottie, object: nil)
    }
}
