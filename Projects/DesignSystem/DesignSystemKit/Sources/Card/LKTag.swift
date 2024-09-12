//
//  LKTag.swift
//  DesignSystemKit
//
//  Created by 안상희 on 6/26/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct LKTag: View {
    private let tag: String

    public init(_ tag: String) {
        self.tag = tag
    }

    public var body: some View {
        Text("# \(tag)")
            .font(weight: .bold, semantic: .xs)
            .foregroundStyle(DesignSystemKitAsset.Colors.g7.swiftUIColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .frame(height: 24)
            .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
            .border(DesignSystemKitAsset.Colors.g3.swiftUIColor, width: 1)
            .lineLimit(1)
    }
}
