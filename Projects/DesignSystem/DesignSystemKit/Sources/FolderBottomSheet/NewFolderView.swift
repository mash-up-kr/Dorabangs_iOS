//
//  NewFolderView.swift
//  DesignSystemKit
//
//  Created by 박소현 on 7/1/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct NewFolderView: View {
    public init() {}

    public var body: some View {
        HStack {
            RoundedRectangle(cornerSize: .init(width: 4, height: 4))
                .stroke(DesignSystemKitAsset.Colors.g9.swiftUIColor, style: StrokeStyle(lineWidth: 0.5, dash: [4]))
                .frame(width: 24, height: 24)

            Text("새 폴더 추가")
                .font(weight: .regular, semantic: .caption3)

            Spacer()
        }
        .frame(height: 52)
    }
}
