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
        LKTabBar(
            selection: $selectedIndex,
            tabItems: [
                LKTabBarItem(
                    tag: 0,
                    title: "홈",
                    image: DesignSystemKitAsset.Icons.icNavigationHome.swiftUIImage,
                    selectedImage: DesignSystemKitAsset.Icons.icNavigationHomeFilled.swiftUIImage
                ),
                LKTabBarItem(
                    tag: 1,
                    title: "보관함",
                    image: DesignSystemKitAsset.Icons.icNavigationFolder.swiftUIImage,
                    selectedImage: DesignSystemKitAsset.Icons.icNavigationFolderFilled.swiftUIImage
                )
            ]
        )
    }
}

#Preview {
    TabBarPreview()
}
