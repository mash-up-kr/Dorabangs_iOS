//
//  LKTopLogoBar.swift
//  DesignSystemKit
//
//  Created by 안상희 on 6/27/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct LKTopLogoBar: View {
    private let action: () -> Void

    public init(action: @escaping () -> Void) {
        self.action = action
    }

    public var body: some View {
        HStack(spacing: 0) {
            // TODO: 로고로 변경 필요
            Color.pink
                .frame(width: 51, height: 26)

            Spacer()

            Button(action: action) {
                Image(.icLink)
                    .frame(width: 24, height: 24)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
    }
}
