//
//  LKTextLeftTopBar.swift
//  DesignSystemKit
//
//  Created by 안상희 on 6/27/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct LKTextLeftTopBar: View {
    private let title: String?
    private let rightButtonEnabled: Bool?
    private let action: () -> Void

    public init(
        title: String? = nil,
        rightButtonEnabled: Bool? = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.rightButtonEnabled = rightButtonEnabled
        self.action = action
    }

    public var body: some View {
        HStack(spacing: 16) {
            Image(.icChevron)
                .frame(width: 24, height: 24)

            if let title {
                Text(title)
                    .font(weight: .bold, semantic: .base1)
            }

            Spacer()

            if let rightButtonEnabled, rightButtonEnabled {
                Button(action: action) {
                    // TODO: ... 버튼으로 변경
                    Text("..")
                }
                .frame(width: 24, height: 24)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}
