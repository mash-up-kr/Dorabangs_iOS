//
//  Shadow.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/27/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public extension View {
    func shadow(
        color: Color,
        blur: CGFloat,
        x: CGFloat,
        y: CGFloat
    ) -> some View {
        shadow(color: color, radius: blur / UIScreen.main.scale, x: x, y: y)
    }

    func dropShadow() -> some View {
        shadow(color: Color(red: 0.15, green: 0.16, blue: 0.17).opacity(0.12), blur: 16, x: 0, y: 4)
    }

    func tabShadow() -> some View {
        shadow(color: Color(red: 0.4, green: 0.44, blue: 1).opacity(0.01), blur: 12, x: 0, y: 4)
    }
}
