//
//  AnalyticsManager.swift
//  Common
//
//  Created by 김영균 on 8/23/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import FirebaseAnalytics

public struct AnalyticsManager: Sendable {
    public static func log(event: some AnalyticsEvent) {
        Analytics.logEvent(event.name, parameters: event.parameters)
    }
}
