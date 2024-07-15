//
//  HomeCardEmptyView.swift
//  Home
//
//  Created by 안상희 on 7/10/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import SwiftUI

struct HomeCardEmptyView: View {
    var body: some View {
        VStack(spacing: 12) {
            Spacer()

            DesignSystemKitAsset.Icons.icEmpty.swiftUIImage
                .frame(width: 40, height: 40)

            Text("생성된 게시글이 없어요")
                .font(weight: .medium, semantic: .caption3)
                .foregroundStyle(DesignSystemKitAsset.Colors.g3.swiftUIColor)
                .frame(maxWidth: .infinity)

            Spacer()
        }
        .frame(height: 260, alignment: .center)
        .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
    }
}
