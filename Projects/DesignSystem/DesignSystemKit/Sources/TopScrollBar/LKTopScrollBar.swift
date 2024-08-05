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
    @State var selectedIndex: Int

    public init(
        titleList: [String],
        selectedIndex: Int
    ) {
        self.titleList = titleList
        self.selectedIndex = selectedIndex
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(titleList.indices, id: \.self) { index in
                    LKTopTabView(
                        folderType: .all,
                        isSelected: selectedIndex == index,
                        title: titleList[index],
                        count: ""
                    )
                    .frame(height: 50)
                    .onTapGesture {
                        selectedIndex = index
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    LKTopScrollBar(
        titleList: ["전체", "즐겨찾기", "나중에 읽을 링크", "나즁에 또 읽을 링크", "영원히 안 볼 링크"],
        selectedIndex: 0
    )
}
