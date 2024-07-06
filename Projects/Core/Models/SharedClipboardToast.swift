//
//  SharedClipboardToast.swift
//  Models
//
//  Created by 김영균 on 7/5/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation

public struct SharedClipboardToast: Equatable {
    public private(set) var urlString: String
    public private(set) var isCloseButtonTappedAtHome: Bool

    public init(urlString: String = "") {
        self.urlString = urlString
        isCloseButtonTappedAtHome = false
    }

    public mutating func setURLString(_ urlString: String) {
        self.urlString = urlString
        isCloseButtonTappedAtHome = false
    }

    public mutating func closeButtonTappedAtHome() {
        isCloseButtonTappedAtHome = true
    }

    public mutating func clear() {
        urlString = ""
        isCloseButtonTappedAtHome = false
    }
}
