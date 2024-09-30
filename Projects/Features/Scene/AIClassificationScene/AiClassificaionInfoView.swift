//
//  AiClassificaionInfoView.swift
//  Scene
//
//  Created by 박소현 on 9/30/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import LocalizationKit
import SwiftUI

public struct AiClassificaionInfoView: View {
    public var body: some View {
        HStack(alignment: .center, spacing: 6) {
            DesignSystemKitAsset.Icons.icStarMedium
                .swiftUIImage.resizable()
                .frame(width: 16, height: 16)

            Text("AI가 추천하는 폴더입니다. 링크를 옮기면 폴더가 생성됩니다.")
                .foregroundStyle(DesignSystemKitAsset.Colors.g2.swiftUIColor)
                .font(weight: .regular, semantic: .s)

            Spacer()
        }
        .frame(height: 40)
        .padding(.horizontal, 12)
        .background(DesignSystemKitAsset.Colors.g8.swiftUIColor)
    }
}
