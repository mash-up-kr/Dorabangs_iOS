//
//  FolderView.swift
//  DesignSystemKit
//
//  Created by 박소현 on 7/1/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct FolderView: View {
    private let title: String
    var isSelected: Bool

    public init(title: String, isSelected: Bool) {
        self.title = title
        self.isSelected = isSelected
    }

    public var body: some View {
        HStack {
            Text(title)
                .font(weight: isSelected ? .bold : .regular, semantic: .caption3)
                .foregroundStyle(DesignSystemKitAsset.Colors.g8.swiftUIColor)

            Spacer()

            Image(.icCheck)
                .resizable()
                .frame(width: 24, height: 24)
                .hidden(!isSelected)
        }
    }
}
