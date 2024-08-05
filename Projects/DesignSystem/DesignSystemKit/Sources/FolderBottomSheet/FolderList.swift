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
    @State var selectedIndex: Int?
    var onSelect: (Int) -> Void

    public init(folders: [String], onSelect: @escaping (Int) -> Void) {
        self.folders = folders
        self.onSelect = onSelect
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(folders.indices, id: \.self) {
                index in
                Divider()
                    .frame(height: 0.5)
                    .background(DesignSystemKitAsset.Colors.g3.swiftUIColor)
                    .padding(.horizontal, 16)

                FolderView(title: folders[index], isSelected: selectedIndex == index)
                    .background(Rectangle().fill(Color.clear).contentShape(.rect))
                    .padding(.horizontal, 16)
                    .frame(height: 52)
                    .onTapGesture {
                        selectedIndex = index
                        onSelect(index)
                    }
            }
        }
    }
}
