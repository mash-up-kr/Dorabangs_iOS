//
//  TabBarPreview.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/24/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import SwiftUI

struct TabBarPreview: View {
    @State private var selectedIndex: Int = 0
    
    var body: some View {
        LKTabView(
            selection: $selectedIndex,
            content: {
                Text("홈")
                    .tag(0)
                
                Text("보관함")
                    .tag(1)
            },
            tabItems: [
                LKTabBarItem(
                    tag: 0,
                    title: "홈",
                    image: DesignSystemKitAsset.Icons.icHome.swiftUIImage,
                    selectedImage: DesignSystemKitAsset.Icons.icHomeFilled.swiftUIImage
                ),
                LKTabBarItem(
                    tag: 1,
                    title: "보관함",
                    image: DesignSystemKitAsset.Icons.icFloder.swiftUIImage,
                    selectedImage: DesignSystemKitAsset.Icons.icFloderFilled.swiftUIImage
                )
            ]
        )
    }
}

#Preview {
    TabBarPreview()
}
