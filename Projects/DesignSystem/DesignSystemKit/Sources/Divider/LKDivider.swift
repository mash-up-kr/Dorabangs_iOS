//
//  LKDivider.swift
//  DesignSystemKit
//
//  Created by 김영균 on 9/3/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct LKDivider: View {
    public init() {}

    public var body: some View {
        Divider()
            .frame(height: 1)
            .overlay(DesignSystemKitAsset.Colors.g2.swiftUIColor)
    }
}
