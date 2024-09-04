//
//  FolderBottomSheet.swift
//  DesignSystemKit
//
//  Created by 박소현 on 6/27/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import LocalizationKit
import SwiftUI

public struct FolderBottomSheet: View {
    @Binding private var isPresented: Bool
    @State private var yOffset: CGFloat = 0
    private let actionSheetHeight: CGFloat = 0.0

    private let folders: [String]
    private let onSelectNewFolder: () -> Void
    private let onComplete: (String?) -> Void
    @State var selectedIndex: Int?
    private let keywindow = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap(\.windows)
        .first(where: \.isKeyWindow)

    public init(
        isPresented: Binding<Bool>,
        folders: [String],
        onSelectNewFolder: @escaping () -> Void,
        onComplete: @escaping (String?) -> Void
    ) {
        _isPresented = isPresented
        self.folders = folders
        self.onSelectNewFolder = onSelectNewFolder
        self.onComplete = onComplete
    }

    public var body: some View {
        VStack(spacing: 0) {
            DragIndicator()
                .padding(.top, 12)

            Text(LocalizationKitStrings.DesignsSystemKit.moveFolder)
                .foregroundStyle(DesignSystemKitAsset.Colors.g8.swiftUIColor)
                .font(weight: .bold, semantic: .base2)
                .frame(height: 20)
                .frame(minWidth: 0, maxWidth: .infinity)
                .contentShape(Rectangle())
                .gesture(dragGesture)
                .padding(.top, 18)
                .padding(.bottom, 6)

            ScrollView {
                VStack(spacing: 0) {
                    NewFolderView()
                        .onTapGesture(perform: onSelectNewFolder)
                        .padding(.horizontal, 20)
                        .frame(height: 52)

                    LKDivider()

                    FolderList(folders: folders, selectedIndex: $selectedIndex)
                }
            }

            RoundedButton(
                title: LocalizationKitStrings.DesignsSystemKit.completed,
                isDisabled: selectedIndex == nil,
                action: {
                    dismissView()
                    if let selectedIndex {
                        onComplete(folders[selectedIndex])
                    } else {
                        onComplete(nil)
                    }
                }
            )
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            Spacer().frame(height: keywindow?.safeAreaInsets.bottom)
        }
        .frame(height: getMaxHeight(), alignment: .top)
        .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
        .cornerRadius(16, corners: [.topLeft, .topRight])
        .shadow(
            color: DesignSystemKitAsset.Colors.topShadow.swiftUIColor,
            blur: 12,
            x: 0,
            y: -10
        )
        .offset(y: yOffset)
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                yOffset = max(yOffset, value.translation.height)
            }
            .onEnded { value in
                withAnimation(.easeInOut(duration: 0.3)) {
                    let threshold = actionSheetHeight * 0.3
                    if value.translation.height > threshold {
                        isPresented = false
                    } else {
                        yOffset = 0
                    }
                }
            }
    }

    private func dismissView() {
        withAnimation(.easeInOut(duration: 0.3)) {
            isPresented = false
        }
    }

    private func getMaxHeight() -> CGFloat {
        let DEFAULT_HEIGHT = 180
        let CELL_HEIGHT = 52
        let realHeight = CGFloat(DEFAULT_HEIGHT + (folders.count + 1) * CELL_HEIGHT)
        let safeAreaSize = keywindow?.safeAreaInsets

        let screenHeight = UIScreen.main.bounds.size.height - (safeAreaSize?.bottom ?? 0) - (safeAreaSize?.top ?? 0) - 57
        return (realHeight > screenHeight) ? screenHeight : realHeight
    }
}

#Preview {
    FolderBottomSheet(isPresented: .constant(true), folders: ["새폴더", "개폴더", "말폴더"], onSelectNewFolder: {}, onComplete: { _ in })
}
