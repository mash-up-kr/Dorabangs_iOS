//
//  DesignSystemKitAsset+Color.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/15/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation
import SwiftUI

public extension DesignSystemKitAsset.Colors {
    static let gradient1 = LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 1, green: 0.98, blue: 0.98), location: 0.00),
            Gradient.Stop(color: Color(red: 0.98, green: 0.98, blue: 1), location: 0.50),
            Gradient.Stop(color: Color(red: 0.98, green: 0.97, blue: 1), location: 1.00)
        ],
        startPoint: UnitPoint(x: 1, y: 1),
        endPoint: UnitPoint(x: -0.03, y: -0.07)
    )

    static let gradient2 = LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 1, green: 0.96, blue: 0.98), location: 0.00),
            Gradient.Stop(color: Color(red: 0.96, green: 0.96, blue: 1), location: 0.50),
            Gradient.Stop(color: Color(red: 0.95, green: 0.98, blue: 1), location: 1.00)
        ],
        startPoint: UnitPoint(x: 1, y: 1),
        endPoint: UnitPoint(x: -0.03, y: -0.07)
    )

    static let gradient3 = LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 1, green: 0.92, blue: 0.96), location: 0.00),
            Gradient.Stop(color: Color(red: 0.97, green: 0.97, blue: 1), location: 0.50),
            Gradient.Stop(color: Color(red: 0.89, green: 0.93, blue: 1), location: 1.00)
        ],
        startPoint: UnitPoint(x: 1, y: 1),
        endPoint: UnitPoint(x: -0.03, y: -0.07)
    )

    static let gradient4 = LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 0.47, green: 0.56, blue: 1), location: 0.00),
            Gradient.Stop(color: Color(red: 0.46, green: 0.32, blue: 1), location: 1.00)
        ],
        startPoint: UnitPoint(x: 1, y: 1),
        endPoint: UnitPoint(x: -0.03, y: -0.07)
    )

    static let gradient5 = LinearGradient(
        gradient: Gradient(
            colors: [
                Color(red: 0.47, green: 0.56, blue: 1),
                Color(red: 0.46, green: 0.32, blue: 1)
            ]
        ),
        startPoint: .bottomTrailing,
        endPoint: .topLeading
    )

    static let gradient6 = LinearGradient(
        stops: [
            Gradient.Stop(color: Color(red: 1, green: 0.58, blue: 0.78).opacity(0.1), location: 0.00),
            Gradient.Stop(color: Color(red: 0.63, green: 0.62, blue: 1).opacity(0.1), location: 0.50),
            Gradient.Stop(color: Color(red: 0.54, green: 0.86, blue: 1).opacity(0.1), location: 1.00)
        ],
        startPoint: UnitPoint(x: 1, y: 1),
        endPoint: UnitPoint(x: -0.03, y: -0.07)
    )
}

public extension DesignSystemKitAsset.Colors {
    static let allCases: [DesignSystemKitColors] = extendGray + opacity + various
    static let extendGray: [DesignSystemKitColors] = [
        Self.g1, Self.g2, Self.g3, Self.g4, Self.g5, Self.g6, Self.g7, Self.g8, Self.g9
    ]
    static let opacity: [DesignSystemKitColors] = [Self.dimmed]
    static let various: [DesignSystemKitColors] = [Self.alert, Self.primary]
    static let gradient: [LinearGradient] = [Self.gradient1, Self.gradient2, Self.gradient3, Self.gradient4, Self.gradient5]
}

extension DesignSystemKitColors: Hashable {
    public static func == (lhs: DesignSystemKitColors, rhs: DesignSystemKitColors) -> Bool {
        lhs.name == rhs.name
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }
}
