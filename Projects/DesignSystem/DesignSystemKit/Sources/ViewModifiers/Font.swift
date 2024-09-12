//
//  Font.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/18/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI
import UIKit

public extension View {
    func font(
        weight: DesignSystemKitAsset.Typography.Weight,
        semantic: DesignSystemKitAsset.Typography.Semantic
    ) -> some View {
        modifier(FontStyle(weight: weight, semantic: semantic))
    }
}

private struct FontStyle: ViewModifier {
    var weight: DesignSystemKitAsset.Typography.Weight
    var semantic: DesignSystemKitAsset.Typography.Semantic

    func body(content: Content) -> some View {
        let font = UIFont.nanumSquareNeo(size: semantic.size.rawValue, weight: weight.value)

        content
            .font(Font(font))
            .lineSpacing(semantic.lineHeight.rawValue - font.lineHeight)
            .padding(.vertical, (semantic.lineHeight.rawValue - font.lineHeight) / 2)
            .kerning(semantic.letterSpacing.rawValue)
    }
}

public extension UIFont {
    // 출처: https://github.com/dufflink/vfont
    static func nanumSquareNeo(size: CGFloat, weight: CGFloat) -> UIFont {
        let fontName = DesignSystemKitAsset.Typography.Font.nanumSquareNeo.rawValue
        guard let uiFont = UIFont(name: fontName, size: size) else {
            fatalError("Call DesignSystemKitAsset.Typography.registerFont() at App init")
        }
        let key = kCTFontVariationAttribute as UIFontDescriptor.AttributeName
        let weightVariationKey = 2_003_265_652
        let uiFontDescriptor = UIFontDescriptor(fontAttributes: [.name: uiFont.fontName, key: [weightVariationKey: weight]])
        return UIFont(descriptor: uiFontDescriptor, size: uiFont.pointSize)
    }
}
