//
//  LKTextFieldPopup.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/21/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct LKTextFieldPopup: View {
    private let headerText: String?

    @Binding private var text: String
    private let fieldText: String?
    private let placeholder: String?
    private let helperText: String?
    private let textLimit: Int?
    private let isWarning: Bool

    private let onCancel: () -> Void
    private let confirmText: String
    private let onConfirm: () -> Void

    public init(
        headerText: String?,
        text: Binding<String>,
        fieldText: String?,
        placeholder: String?,
        helperText: String?,
        textLimit: Int?,
        isWarning: Bool,
        onCancel: @escaping () -> Void,
        confirmText: String,
        onConfirm: @escaping () -> Void
    ) {
        self.headerText = headerText
        _text = text
        self.fieldText = fieldText
        self.placeholder = placeholder
        self.helperText = helperText
        self.textLimit = textLimit
        self.isWarning = isWarning
        self.onCancel = onCancel
        self.confirmText = confirmText
        self.onConfirm = onConfirm
    }

    public var body: some View {
        VStack(spacing: 0) {
            if let headerText {
                HeaderLabel(headerText: headerText)
            }

            Spacer()
                .frame(height: 22)

            LKTextField(
                text: $text,
                fieldText: fieldText,
                placeholder: placeholder,
                helperText: helperText,
                textLimit: textLimit,
                isWarning: isWarning
            )
            .submitLabel(.done)
            .onSubmit(onConfirm)

            Spacer()
                .frame(height: 14)

            HStack(spacing: 8) {
                RoundedCornersButton(
                    title: "닫기",
                    style: .solidGray,
                    action: onCancel
                )
                RoundedCornersButton(
                    title: confirmText,
                    style: .solidBlack,
                    action: onConfirm
                )
            }
            .padding(20)
        }
        .frame(width: 350)
        .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
        .cornerRadius(12, corners: .allCorners)
    }
}

private struct HeaderLabel: View {
    let headerText: String

    private enum Layout {
        static let headerLabelHeight: CGFloat = 24
        static let horizontalPadding: CGFloat = 20
        static let verticalPadding: CGFloat = 12
    }

    var body: some View {
        Text(headerText)
            .font(weight: .bold, semantic: .base1)
            .foregroundStyle(DesignSystemKitAsset.Colors.g9.swiftUIColor)
            .frame(height: Layout.headerLabelHeight)
            .padding(.horizontal, Layout.horizontalPadding)
            .padding(.vertical, Layout.verticalPadding)
    }
}

#Preview {
    LKTextFieldPopup(
        headerText: "폴더 이름 변경",
        text: .constant(""),
        fieldText: "폴더명",
        placeholder: "폴더명을 입력해주세요.",
        helperText: "같은 이름의 폴더가 있어요.",
        textLimit: 15,
        isWarning: true,
        onCancel: {},
        confirmText: "생성",
        onConfirm: {}
    )
}
