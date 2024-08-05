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
}
