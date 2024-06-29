//
//  DesignSystemKitAsset+Color.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/15/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation

public extension DesignSystemKitAsset.Colors {
    static let allCases: [DesignSystemKitColors] = extendGray + opacity + various
    static let extendGray: [DesignSystemKitColors] = [
        Self.g1, Self.g2, Self.g3, Self.g4, Self.g5, Self.g6, Self.g7, Self.g8, Self.g9
    ]
    static let opacity: [DesignSystemKitColors] = [Self.dimmed]
    static let various: [DesignSystemKitColors] = [Self.alert]
}

extension DesignSystemKitColors: Hashable {
    public static func == (lhs: DesignSystemKitColors, rhs: DesignSystemKitColors) -> Bool {
        lhs.name == rhs.name
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
