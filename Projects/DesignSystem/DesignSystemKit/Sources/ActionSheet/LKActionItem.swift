//
//  LKActionItem.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/27/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct LKActionItem {
    public enum Style {
        case `default`, destructive
    }
    let title: String
    let image: Image?
    let style: Style
    let action: (() -> Void)?
    
    public init(
        title: String,
        image: Image? = nil,
        style: Style = .default,
        action: (() -> Void)? = nil
    ) {
        self.style = style
        self.image = image
        self.title = title
        self.action = action
    }
}
