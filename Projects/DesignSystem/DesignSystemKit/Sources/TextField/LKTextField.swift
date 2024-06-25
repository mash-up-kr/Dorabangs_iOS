//
//  LKTextField.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/20/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct LKTextField: View {
    @Binding private var text: String
    private let fieldText: String?
    private let placeholder: String?
    private let helperText: String?
    private let textLimit: Int?
    private let isWarning: Bool
    
    private enum Layout {
        static let verticalSpacing: CGFloat = 8
        static let inputFieldCornerRadius: CGFloat = 8
        static let inputFieldBorderWidth: CGFloat = 1
    }
    
    public init(
        text: Binding<String>,
        fieldText: String? = nil,
        placeholder: String? = nil,
        helperText: String? = nil,
        textLimit: Int? = nil,
        isWarning: Bool = false
    ) {
        self._text = text
        self.fieldText = fieldText
        self.placeholder = placeholder
        self.helperText = helperText
        self.textLimit = textLimit
        self.isWarning = isWarning
    }
    
    public var body: some View {
        VStack(spacing: Layout.verticalSpacing) {
            if let fieldText = fieldText {
                FieldLabel(title: fieldText)
            }
            
            InputField(text: $text, placeholder: placeholder)
                .tint(
                    isWarning
                    ? DesignSystemKitAsset.Colors.alert.swiftUIColor
                    : DesignSystemKitAsset.Colors.g9.swiftUIColor
                )
                .border(
                    isWarning
                    ? DesignSystemKitAsset.Colors.alert.swiftUIColor
                    : Color.clear,
                    width: Layout.inputFieldBorderWidth,
                    cornerRadius: Layout.inputFieldCornerRadius
                )
            
            HStack {
                if let helperText = helperText {
                    HelperLabel(title: helperText)
                        .foregroundStyle(
                            isWarning
                            ? DesignSystemKitAsset.Colors.alert.swiftUIColor
                            : Color.clear
                        )
                }
                
                Spacer()
                
                if let textLimit = textLimit {
                    CounterLabel(text: text, limit: textLimit)
                }
            }
        }
        .padding(.horizontal, 20)
        .onChange(of: text) { _, newValue in
            if let textLimit = textLimit, newValue.count > textLimit {
                text = String(text.prefix(textLimit))
            }
        }
    }
}

// MARK: - Field Label
private struct FieldLabel: View {
    let title: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(weight: .medium, semantic: .caption1)
                .foregroundStyle(DesignSystemKitAsset.Colors.g9.swiftUIColor)
            
            Spacer()
        }
    }
}

// MARK: InputField
private struct InputField: View {
    @Binding var text: String
    let placeholder: String?
    @FocusState private var isFocused: Bool
    private var isClearButtonShowing: Bool { isFocused && text.isEmpty == false }
    
    private enum Layout {
        static let horizontalPadding: CGFloat = 12
        static let verticalPadding: CGFloat = 14
        static let cornerRadius: CGFloat = 8
        static let frameHeight: CGFloat = 48
        static let iconSize: CGFloat = 24
        static let placeholderLeadingPadding: CGFloat = 16
    }
    
    var body: some View {
        HStack {
            textField()
            clearButton()
        }
        .padding(.horizontal, Layout.horizontalPadding)
        .padding(.vertical, Layout.verticalPadding)
        .frame(maxWidth: .infinity, minHeight: Layout.frameHeight, maxHeight: Layout.frameHeight)
        .background {
            DesignSystemKitAsset.Colors.g1.swiftUIColor
                .overlay(content: placeholderLabel)
        }
        .cornerRadius(Layout.cornerRadius, corners: .allCorners)
    }
    
    private func textField() -> some View {
        TextField("", text: $text)
            .focused($isFocused)
            .labelsHidden()
            .autocorrectionDisabled()
            .font(weight: .medium, semantic: .caption1)
            .foregroundStyle(DesignSystemKitAsset.Colors.g9.swiftUIColor)
    }
    
    private func clearButton() -> some View {
        Button(action: { text = "" }) {
            DesignSystemKitAsset.Icons.icCloseWhite.swiftUIImage
                .resizable()
                .frame(width: Layout.iconSize, height: Layout.iconSize)
        }
        .scaleEffect(isClearButtonShowing ? 1 : 0)
        .animation(.easeInOut(duration: 0.2), value: isClearButtonShowing)
    }
    
    @ViewBuilder
    private func placeholderLabel() -> some View {
        if text.isEmpty, let placeholder = placeholder {
            HStack {
                Text(placeholder)
                    .font(weight: .medium, semantic: .caption1)
                    .foregroundStyle(DesignSystemKitAsset.Colors.g4.swiftUIColor)
                    .padding(.leading, Layout.placeholderLeadingPadding)
                
                Spacer()
            }
        }
    }
}

// MARK: - Helper Label
private struct HelperLabel: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(weight: .medium, semantic: .s)
    }
}

// MARK: - Counter Text
private struct CounterLabel: View {
    let text: String
    let limit: Int
    
    var body: some View {
        Text("\(text.count)/\(limit)")
            .font(weight: .medium, semantic: .s)
            .foregroundStyle(DesignSystemKitAsset.Colors.g6.swiftUIColor)
    }
}

#Preview {
    LKTextField(
        text: .constant("text"),
        fieldText: "폴더명",
        placeholder: "텍스트를 입력하세요",
        helperText: "같은 이름의 폴더가 있어요.",
        textLimit: 20,
        isWarning: true
    )
}
