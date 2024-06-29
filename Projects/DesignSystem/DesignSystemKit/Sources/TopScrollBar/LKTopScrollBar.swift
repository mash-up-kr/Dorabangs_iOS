//
//  LKTopScrollBar.swift
//  DesignSystemUI
//
//  Created by 안상희 on 6/30/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct LKTopScrollBar: View {
    private let titleList: [String]
    private let selectedIndex: Int
    private let action: () -> Void

    public init(
        titleList: [String],
        selectedIndex: Int,
        action: @escaping () -> Void
    ) {
        self.titleList = titleList
        self.selectedIndex = selectedIndex
        self.action = action
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(titleList.indices, id: \.self) { index in
                    LKTopTabView(
                        isSelected: selectedIndex == index,
                        title: titleList[index],
                        count: "",
                        action: {}
                    )
                    .frame(height: 50)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
        }
    }
}

#Preview {
    LKTopScrollBar(
        titleList: ["전체", "즐겨찾기", "나중에 읽을 링크", "나즁에 또 읽을 링크", "영원히 안 볼 링크"],
        selectedIndex: 0,
        action: {}
    )
}
