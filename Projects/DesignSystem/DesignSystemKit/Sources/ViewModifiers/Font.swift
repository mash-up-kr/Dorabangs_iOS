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
        let font = nanumSqureNeo().with(weight: weight.uikitFontWeight)

        content
            .font(Font(font))
            .lineSpacing(semantic.lineHeight.rawValue - font.lineHeight)
            .padding(.vertical, (semantic.lineHeight.rawValue - font.lineHeight) / 2)
    }

    func nanumSqureNeo() -> UIFont {
        let fontName = DesignSystemKitAsset.Typography.Font.nanumSquareNeo.rawValue
        guard let font = UIFont(name: fontName, size: semantic.size.rawValue) else {
            fatalError("Call DesignSystemKitAsset.Typography.registerFont() at App init")
        }
        return font
    }
}

extension UIFont {
    /// Returns a font object that is the same as the receiver but which has the specified weight and symbolic traits
    func with(weight: Weight) -> UIFont {
        var traits = fontDescriptor.fontAttributes[.traits] as? [String: Any] ?? [:]
        traits[kCTFontWeightTrait as String] = weight

        var fontAttributes: [UIFontDescriptor.AttributeName: Any] = [:]
        fontAttributes[.family] = familyName
        fontAttributes[.traits] = traits

        return UIFont(descriptor: UIFontDescriptor(fontAttributes: fontAttributes), size: pointSize)
    }
}
