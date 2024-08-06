//
//  String+Extension.swift
//  Common
//
//  Created by 안상희 on 7/18/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation
import LocalizationKit

public extension Date {
    func timeAgo() -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: self, to: now)

        guard let day = components.day else { return "알 수 없음" }

        switch day {
        case 0:
            return LocalizationKitStrings.Common.today
        case 1:
            return LocalizationKitStrings.Common.yesterday
        default:
            return LocalizationKitStrings.Common.daysAgo(day)
        }
    }
}
