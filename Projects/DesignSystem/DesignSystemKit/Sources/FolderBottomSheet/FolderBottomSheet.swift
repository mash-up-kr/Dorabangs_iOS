//
//  FolderBottomSheet.swift
//  DesignSystemKit
//
//  Created by 박소현 on 6/27/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct FolderBottomSheet: View {
    @Binding private var isPresented: Bool
    @State private var yOffset: CGFloat = 0
    private let actionSheetHeight: CGFloat = 0.0
    
    private let folders: [String]
    private let onComplete: (String?) -> Void
    var selectedIndex: Int?
    private let keywindow = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap(\.windows)
        .first(where: \.isKeyWindow)
    
    public init(
        isPresented: Binding<Bool>,
        folders: [String],
        onComplete: @escaping (String?) -> Void
    ) {
        self._isPresented = isPresented
        self.folders = folders
        self.onComplete = onComplete
    }
    public var body: some View {
        VStack(spacing: 0) {
            
            DragIndicator()
                .padding(.top, 6)
            
            Text("폴더 이동")
                .font(weight: .bold, semantic: .base2)
                .frame(height: 56)
                .frame(minWidth: 0, maxWidth: .infinity)
                .contentShape(Rectangle())
                .gesture(dragGesture)
            
            ScrollView {
                VStack(spacing: 0) {
                    NewFolderView()
                        .padding(.horizontal, 16)
                        .frame(height: 52)
                    
                    FolderList(
                        folders: self.folders,
                        onSelect: { index in
                            print("tap folder : \(folders[index])")
                        }
                    )
                }
            }
            
            RoundedButton(title: "완료", action: {
                dismissView()
                if let selectedIndex = selectedIndex {
                    self.onComplete(folders[selectedIndex])
                } else {
                    self.onComplete(nil)
                }
            })
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .safeAreaPadding(.bottom)
        
        .frame(height: self.getMaxHeight(), alignment: .top)
        .background(DesignSystemKitAsset.Colors.g1.swiftUIColor)
        .cornerRadius(16, corners: .allCorners)
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
        let realHeight = CGFloat((DEFAULT_HEIGHT + (folders.count + 1) * CELL_HEIGHT))
        let safeAreaSize = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? [] }.last { $0.isKeyWindow }?.safeAreaInsets
        
        let screenHeight = UIScreen.main.bounds.size.height - (safeAreaSize?.bottom ?? 0) - (safeAreaSize?.top ?? 0) - 57
        return (realHeight > screenHeight ) ? screenHeight : realHeight
    }
}

#Preview {
    FolderBottomSheet(isPresented: .constant(true), folders: ["새폴더", "개폴더", "말폴더"], onComplete: { _ in })
}

private struct NewFolderView: View {
    var body: some View {
        HStack {
            DesignSystemKitAsset.Icons.icCheckmark
                .swiftUIImage
                .resizable()
                .frame(width: 24, height: 24)
            
            Text("새 폴더 추가")
                .font(weight: .regular, semantic: .caption3)
            
            Spacer()
        }
        .frame(height: 52)
        .background(DesignSystemKitAsset.Colors.g1.swiftUIColor)
        
    }
}
private struct FolderView: View {
    
    private let title: String
    var isSelected: Bool
    
    public init(title: String, isSelected: Bool) {
        self.title = title
        self.isSelected = isSelected
    }
    
    var body: some View {
        HStack {
            Image(.icFloderFilled)
                .resizable()
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(weight: .regular, semantic: .caption3)
            
            Spacer()
            
            Image(.icSelect)
                .resizable()
                .frame(width: 24, height: 24)
                .hidden(!isSelected)
        }
        .background(DesignSystemKitAsset.Colors.g1.swiftUIColor)
    }
}
private struct FolderList: View {
    let folders: [String]
    @State var selectedIndex: Int?
    var onSelect: (Int) -> Void
    
    public init(folders: [String], onSelect: @escaping (Int) -> Void) {
        self.folders = folders
        self.onSelect = onSelect
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(folders.indices, id: \.self) {
                index in
                Divider()
                    .frame(height: 0.5)
                    .background(DesignSystemKitAsset.Colors.g3.swiftUIColor)
                    .padding(.horizontal, 16)
                
                FolderView(title: folders[index], isSelected: (selectedIndex == index))
                    .padding(.horizontal, 16)
                    .frame(height: 52)
                    .onTapGesture {
                        self.selectedIndex = index
                        self.onSelect(index)
                    }
            }
            
        }
    }
}
