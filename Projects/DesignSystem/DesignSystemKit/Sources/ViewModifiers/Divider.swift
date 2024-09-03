//
//  Divider.swift
//  DesignSystemKit
//
//  Created by 김영균 on 9/3/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public extension View {
    func dividerLine(edge: Edge, lineWidth: CGFloat = 1) -> some View {
        switch edge {
        case .top:
            AnyView(erasing: overlay { TopLine().stroke(DesignSystemKitAsset.Colors.g2.swiftUIColor, lineWidth: lineWidth) })
        case .leading:
            AnyView(erasing: overlay { LeadingLine().stroke(DesignSystemKitAsset.Colors.g2.swiftUIColor, lineWidth: lineWidth) })
        case .bottom:
            AnyView(erasing: overlay { BottomLine().stroke(DesignSystemKitAsset.Colors.g2.swiftUIColor, lineWidth: lineWidth) })
        case .trailing:
            AnyView(erasing: overlay { TrailingLine().stroke(DesignSystemKitAsset.Colors.g2.swiftUIColor, lineWidth: lineWidth) })
        }
    }
}

public struct TopLine: Shape {
    public func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: 0))
        return path
    }
}

public struct BottomLine: Shape {
    public func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        return path
    }
}

public struct LeadingLine: Shape {
    public func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        return path
    }
}

public struct TrailingLine: Shape {
    public func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.maxX, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        return path
    }
}
