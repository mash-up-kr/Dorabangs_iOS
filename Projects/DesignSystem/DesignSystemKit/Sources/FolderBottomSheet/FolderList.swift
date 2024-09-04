//
//  FolderList.swift
//  DesignSystemKit
//
//  Created by 박소현 on 7/1/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct FolderList: View {
    let folders: [String]
    @Binding var selectedIndex: Int?

    public init(folders: [String], selectedIndex: Binding<Int?>) {
        self.folders = folders
        _selectedIndex = selectedIndex
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(folders.indices, id: \.self) { index in
                FolderView(title: folders[index], isSelected: selectedIndex == index)
                    .background(Rectangle().fill(Color.clear).contentShape(.rect))
                    .padding(.horizontal, 20)
                    .frame(height: 52)
                    .background(selectedIndex == index ? DesignSystemKitAsset.Colors.g1.swiftUIColor : DesignSystemKitAsset.Colors.white.swiftUIColor)
                    .onTapGesture {
                        selectedIndex = index
                    }

                LKDivider()
            }
        }
    }
}
