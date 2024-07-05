//
//  ColorPreview.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/18/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import SwiftUI
import UIKit

struct ColorPreview: View {
    private typealias Section = (title: String, colors: [DesignSystemKitColors])
    private let sections: [Section] = [
        ("Extended Gray", DesignSystemKitAsset.Colors.extendGray),
        ("Opacity", DesignSystemKitAsset.Colors.opacity),
        ("Various", DesignSystemKitAsset.Colors.various)
    ]

    var body: some View {
        PreviewList(title: "Color") {
            colorsPreview()
            gradientPreview()
        }
    }

    @ViewBuilder
    func colorsPreview() -> some View {
        ForEach(sections, id: \.title) { section in
            PreviewSection(title: section.title) {
                ForEach(section.colors, id: \.self) {
                    ColorRowView(color: $0)
                        .listRowSeparator(.hidden)
                }
            }
        }
    }

    @ViewBuilder
    func gradientPreview() -> some View {
        let colors = DesignSystemKitAsset.Colors.gradient
        PreviewSection(title: "Gradient") {
            ForEach(colors.indices, id: \.self) { index in
                GradientRowView(name: "Gradient\(index + 1)", gradient: colors[index])
                    .listRowSeparator(.hidden)
            }
        }
    }
}

private struct ColorRowView: View {
    let color: DesignSystemKitColors

    var body: some View {
        HStack {
            Circle()
                .fill(color.swiftUIColor)
                .frame(width: 48, height: 48)

            VStack(alignment: .leading, spacing: 8) {
                Text(color.name)
                    .font(.system(.title3).bold())
                    .foregroundStyle(.primary)

                Text(color.color.toHex() ?? "")
                    .font(.system(.caption))
                    .foregroundStyle(.secondary)
            }
        }
    }
}

private struct GradientRowView: View {
    let name: String
    let gradient: LinearGradient

    var body: some View {
        HStack {
            Circle()
                .fill(gradient)
                .frame(width: 48, height: 48)

            Text(name)
                .font(.system(.title3).bold())
                .foregroundStyle(.primary)
        }
    }
}

private extension UIColor {
    // UIColor를 hex 코드 문자열로 변환하는 함수
    func toHex() -> String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        guard getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }

        if alpha == 1.0 {
            let rgb = Int(red * 255) << 16 | Int(green * 255) << 8 | Int(blue * 255) << 0
            return String(format: "#%06X", rgb)
        } else {
            let rgba = Int(red * 255) << 24 |
                Int(green * 255) << 16 |
                Int(blue * 255) << 8 |
                Int(alpha * 255) << 0
            return String(format: "#%08X", rgba)
        }
    }
}

private extension Color {
    // Color를 UIColor로 변환하는 함수
    func toHex() -> String? {
        let uiColor = UIColor(self)
        return uiColor.toHex()
    }
}

#Preview {
    ColorPreview()
}
