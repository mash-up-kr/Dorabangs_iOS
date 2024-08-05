//
//  FeedEmptyView.swift
//  Feed
//
//  Created by 박소현 on 7/31/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import SwiftUI

struct FeedEmptyView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 12) {
            DesignSystemKitAsset.Icons.icEmpty.swiftUIImage
                .frame(width: 40, height: 40)

            Text("아직 생성된 게시글이 없어요")
                .font(weight: .medium, semantic: .caption3)
                .foregroundStyle(DesignSystemKitAsset.Colors.g3.swiftUIColor)
                .frame(maxWidth: .infinity)
        }
        .frame(alignment: .center)
        .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
    }
}
