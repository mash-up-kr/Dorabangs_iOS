//
//  LineHeight.swift
//  DesignSystem
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public extension View {
    func lineHeight(_ lineHeight: CGFloat, for font: UIFont) -> some View {
        modifier(LineHeightViewModifier(font: font, lineHeight: lineHeight))
    }
}

private struct LineHeightViewModifier: ViewModifier {
    let font: UIFont
    let lineHeight: CGFloat
    
    func body(content: Content) -> some View {
        content
            .font(Font(font))
            .lineSpacing(lineHeight - font.lineHeight)
            .padding(.vertical, (lineHeight - font.lineHeight) / 2)
    }
}
