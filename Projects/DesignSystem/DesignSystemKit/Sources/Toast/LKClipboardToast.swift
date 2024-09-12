//
//  LKClipboardToast.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/26/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import LocalizationKit
import SwiftUI

public struct LKClipboardToast: View {
    private let urlString: String
    private let saveAction: () -> Void
    private let closeAction: () -> Void
    private var window: UIWindow? {
        UIApplication
            .shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
            .first(where: \.isKeyWindow)
    }

    public init(
        urlString: String,
        saveAction: @escaping () -> Void,
        closeAction: @escaping () -> Void
    ) {
        self.urlString = urlString
        self.saveAction = saveAction
        self.closeAction = closeAction
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 0) {
                    Text(LocalizationKitStrings.DesignsSystemKit.saveCopiedLink)
                        .font(weight: .regular, semantic: .caption1)
                        .foregroundStyle(DesignSystemKitAsset.Colors.g1.swiftUIColor)
                        .onTapGesture(perform: saveAction)

                    DesignSystemKitAsset.Icons.icChevronRightSmallWhite
                        .swiftUIImage
                        .frame(width: 20, height: 20)
                }
                .frame(height: 24)

                HStack(alignment: .top, spacing: 0) {
                    Text(urlString)
                        .font(weight: .regular, semantic: .caption1)
                        .foregroundStyle(DesignSystemKitAsset.Colors.g4.swiftUIColor)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)

                    Spacer()
                }
            }

            Image(.icCloseWhite)
                .resizable()
                .frame(width: 24, height: 24)
                .onTapGesture(perform: closeAction)
        }
        .padding(16)
        .background(DesignSystemKitAsset.Colors.surfaceBlack.swiftUIColor)
        .cornerRadius(12, corners: .allCorners)
        .shadow(
            color: Color(red: 0.15, green: 0.16, blue: 0.17).opacity(0.12),
            blur: 32,
            x: 0,
            y: 4
        )
    }
}

#Preview {
    LKClipboardToast(
        urlString: "https://www.apple.com?a=b&c=d",
        saveAction: {},
        closeAction: {}
    )
    .padding(.horizontal, 20)
}
