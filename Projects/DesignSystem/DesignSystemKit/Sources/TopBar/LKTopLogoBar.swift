//
//  LKTopLogoBar.swift
//  DesignSystemKit
//
//  Created by 안상희 on 6/27/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct LKTopLogoBar: View {
    public init() {}

    public var body: some View {
        HStack(spacing: 0) {
            Image(.imgLogoText)
                .resizable()
                .scaledToFit()
                .frame(height: 22)

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .frame(height: 48)
    }
}
