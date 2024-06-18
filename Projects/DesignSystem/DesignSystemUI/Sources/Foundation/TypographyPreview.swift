//
//  TypographyPreview.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/18/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import SwiftUI

struct TypographyPreview: View {
    private typealias Section = (title: String, semantics: [DesignSystemKitAsset.Typography.Semantic])
    private let sections: [Section] = [
        ("Header", [.h3, .h4, .h5, .h6]),
        ("Title", [.title, .subtitle1, .subtitle2]),
        ("Base", [.base1, .base2]),
        ("Caption", [.caption1, .caption2, .caption3]),
        ("Small", [.s])
    ]
    @State private var weight: DesignSystemKitAsset.Typography.Weight = .regular
    
    var body: some View {
        PreviewList(title: "Typography") {
            ForEach(sections, id: \.title) { section in
                typographySection(title: section.title, semantics: section.semantics)
            }
        }
        .toolbar(content: weightMenu)
    }
    
    private func typographySection(title: String, semantics: [DesignSystemKitAsset.Typography.Semantic]) -> some View {
        PreviewSection(title: title) {
            ForEach(semantics, id: \.self) { semantic in
                TypoListItem(weight: $weight, semantic: semantic)
            }
        }
    }
    
    private func weightMenu() -> some View {
        Menu("Weight") {
            Picker("Select Weight", selection: $weight) {
                ForEach(DesignSystemKitAsset.Typography.Weight.allCases, id: \.self) { weight in
                    Text(weight.rawValue.capitalized)
                        .tag(weight)
                }
            }
        }
    }
}

private struct TypoListItem: View {
    @Binding var weight: DesignSystemKitAsset.Typography.Weight
    let semantic: DesignSystemKitAsset.Typography.Semantic
    let sampleText = """
    사건은 다가와, ah-oh, ayy
    거세게 커져가, ah-oh, ayy
    질문은 계속돼, ah-oh, ayy
    우린 어디서 왔나, oh, ayy
    """
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(sampleText)
                .font(weight: weight, semantic: semantic)
            
            HStack(spacing: 16) {
                typographyKey
                typographyValue
                Spacer()
            }
            .padding(16)
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(8, corners: .allCorners)
        }
        .padding(.horizontal, 8)
    }
    
    var typographyKey: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("font-type")
            Text("font-weight")
            Text("font-size")
            Text("line-height")
        }
        .font(.system(size: 14, weight: .bold))
        .foregroundStyle(.primary)
    }
    
    var typographyValue: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(semantic.rawValue)
            Text(weight.rawValue)
            Text("\(Int(semantic.size.rawValue))px")
            Text("\(Int(semantic.lineHeight.rawValue))px")
        }
        .font(.system(size: 14, weight: .medium))
        .foregroundStyle(.secondary)
    }
}

#Preview {
    TypographyPreview()
}
