//
//  Font.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/18/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public extension View {
    func font(
        weight: DesignSystemKitAsset.Typography.Weight,
        semantic: DesignSystemKitAsset.Typography.Semantic
    ) -> some View {
        return modifier(FontStyle(weight: weight, semantic: semantic))
    }
}

private struct FontStyle: ViewModifier {
    var weight: DesignSystemKitAsset.Typography.Weight
    var semantic: DesignSystemKitAsset.Typography.Semantic
    
    func body(content: Content) -> some View {
        content
            .lineHeight(semantic.lineHeight.rawValue, for: nanumSqureNeo())
            .fontWeight(weight.swiftUIFontWeight)
    }
    
    func nanumSqureNeo() -> UIFont {
        let fontName = DesignSystemKitAsset.Typography.Font.nanumSquareNeo.rawValue
        guard let font = UIFont(name: fontName, size: semantic.size.rawValue) else {
            fatalError("Call DesignSystemKitAsset.Typography.registerFont() at App init")
        }
        return font
    }
}
