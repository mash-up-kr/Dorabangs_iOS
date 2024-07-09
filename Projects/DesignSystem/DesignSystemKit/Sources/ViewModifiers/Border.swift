//
//  Border.swift
//  DesignSystem
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public extension View {
    func border(_ content: some ShapeStyle, width: CGFloat = 1, cornerRadius: CGFloat) -> some View {
        let roundedCorner = RoundedCorner(radius: cornerRadius, corners: .allCorners)
        return clipShape(roundedCorner)
            .overlay(roundedCorner.stroke(content, lineWidth: width))
    }
}
