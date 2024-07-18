//
//  String+Extension.swift
//  Common
//
//  Created by 안상희 on 7/18/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation

public extension Date {
    func timeAgo() -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: self, to: now)

        guard let day = components.day else { return "알 수 없음" }

        switch day {
        case 0:
            return "오늘"
        case 1:
            return "어제"
        default:
            return "\(day)일 전"
        }
    }
}
