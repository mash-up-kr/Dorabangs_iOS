//
//  ActivityItem.swift
//  DesignSystemKit
//
//  Created by 김영균 on 7/24/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import UIKit

public struct ActivityItem {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]
    var excludedTypes: [UIActivity.ActivityType]

    public init(activityItems: [Any], applicationActivities: [UIActivity] = [], excludedTypes: [UIActivity.ActivityType] = []) {
        self.activityItems = activityItems
        self.applicationActivities = applicationActivities
        self.excludedTypes = excludedTypes
    }
}
