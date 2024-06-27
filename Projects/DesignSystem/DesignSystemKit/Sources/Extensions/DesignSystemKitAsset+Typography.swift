//
//  DesignSystemKitAsset+Typography.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/18/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

extension DesignSystemKitAsset {
    public enum Typography {}
}

public extension DesignSystemKitAsset.Typography {
    enum Font: String {
        case nanumSquareNeo = "NanumSquareNeo-Variable"
    }
    
    enum Weight: String, Hashable, CaseIterable {
        case regular
        case medium
        case bold
    }
    
    enum Size: CGFloat {
        case _48 = 48.0
        case _34 = 34.0
        case _32 = 32.0
        case _28 = 28.0
        case _24 = 24.0
        case _20 = 20.0
        case _18 = 18.0
        case _16 = 16.0
        case _15 = 15.0
        case _14 = 14.0
        case _13 = 13.0
        case _12 = 12.0
        case _11 = 11.0
        case _10 = 10
    }
    
    enum LineHeight: CGFloat {
        case _54 = 54.0
        case _46 = 46.0
        case _38 = 38.0
        case _34 = 34.0
        case _26 = 26.0
        case _24 = 24.0
        case _22 = 22.0
        case _14 = 14.0
    }
    
    enum Semantic: String {
        case h3
        case h4
        case h5
        case h6
        case title
        case subtitle1
        case subtitle2
        case base1
        case base2
        case caption3
        case caption2
        case caption1
        case s
        case xs
    }
}

public extension DesignSystemKitAsset.Typography.Semantic {
    var size: DesignSystemKitAsset.Typography.Size {
        switch self {
        case .h3: return ._48
        case .h4: return ._34
        case .h5: return ._32
        case .h6: return ._28
        case .title: return ._24
        case .subtitle1: return ._20
        case .subtitle2: return ._18
        case .base1: return ._16
        case .base2: return ._15
        case .caption3: return ._14
        case .caption2: return ._13
        case .caption1: return ._12
        case .s: return ._11
        case .xs: return ._10
        }
    }
    
    var lineHeight: DesignSystemKitAsset.Typography.LineHeight {
        switch self {
        case .h3: return ._54
        case .h4: return ._46
        case .h5, .h6: return ._38
        case .title: return ._34
        case .subtitle1, .subtitle2: return ._26
        case .base1, .base2, .caption3: return ._24
        case .caption2, .caption1: return ._22
        case .s, .xs: return ._14
        }
    }
}

public extension DesignSystemKitAsset.Typography.Weight {
    var swiftUIFontWeight: Font.Weight {
        switch self {
        case .regular: return .regular
        case .medium: return .medium
        case .bold: return .bold
        }
    }
    
    var uikitFontWeight: UIFont.Weight {
        switch self {
        case .regular: return .regular
        case .medium: return .medium
        case .bold: return .bold
        }
    }
}

public extension DesignSystemKitAsset.Typography {
    static func registerFont() throws {
        let fileReadUnknownError = NSError(domain: NSCocoaErrorDomain, code: NSFileReadUnknownError, userInfo: nil)        
        guard
            let fontURL = Bundle.module.url(forResource: Font.nanumSquareNeo.rawValue, withExtension: "ttf"),
            let fontDataProvider = CGDataProvider(url: fontURL as CFURL),
            let _ = CGFont(fontDataProvider)
        else {
            throw fileReadUnknownError
        }
        
        var error: Unmanaged<CFError>?
        if !CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error) {
            throw error?.takeUnretainedValue() ?? fileReadUnknownError
        }
    }
}
