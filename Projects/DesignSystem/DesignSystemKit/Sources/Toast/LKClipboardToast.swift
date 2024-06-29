//
//  LKClipboardToast.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/26/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

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
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 0) {
                Text("클립보드에 복사한 링크 저장")
                    .font(weight: .medium, semantic: .caption1)
                    .foregroundStyle(DesignSystemKitAsset.Colors.g3.swiftUIColor)
                    .onTapGesture(perform: saveAction)

                DesignSystemKitAsset.Icons.icChevronRightS.swiftUIImage
                    .resizable()
                    .frame(width: 20, height: 20)
            }

            HStack(alignment: .top, spacing: 0) {
                Text(urlString)
                    .font(weight: .bold, semantic: .caption3)
                    .foregroundStyle(DesignSystemKitAsset.Colors.white.swiftUIColor)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)

                Spacer()

                DesignSystemKitAsset.Icons.icCloseCircle.swiftUIImage
                    .resizable()
                    .frame(width: 24, height: 24)
                    .onTapGesture(perform: closeAction)
            }
        }
        .padding(16)
        .background(DesignSystemKitAsset.Colors.g9.swiftUIColor)
        .cornerRadius(12, corners: .allCorners)
        .shadow(
            color: DesignSystemKitAsset.Colors.black.swiftUIColor.opacity(0.26),
            blur: 20,
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
