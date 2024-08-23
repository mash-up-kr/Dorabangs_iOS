//
//  AnalyticsEvent.swift
//  Services
//
//  Created by 김영균 on 8/23/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation

public protocol AnalyticsEvent {
    var name: String { get }
    var parameters: [String: Any]? { get }
}

public struct ShareExtensionEvent: AnalyticsEvent {
    public enum Name: String {
        case edit_saved_url
    }

    public var name: String
    public var parameters: [String: Any]?

    public init(name: Name) {
        self.name = name.rawValue
        parameters = nil
    }
}
