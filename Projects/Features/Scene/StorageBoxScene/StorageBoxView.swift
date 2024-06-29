//
//  StorageBoxView.swift
//  StorageBox
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import SwiftUI

public struct StorageBoxView: View {
    @State var newFolderPopupIsPresented: Bool = false
    
    private let store: StoreOf<StorageBox>
    
    @State var defaultFolders: [StorageBoxModel] = [
        .init(title: "모든 링크", count: 3),
        .init(title: "즐겨찾기", count: 3),
        .init(title: "나중에 읽을 링크", count: 3)
    ]
    
    @State var customFolders: [StorageBoxModel] = [
        .init(title: "에스파", count: 3),
        .init(title: "아이브", count: 3),
        .init(title: "카리나", count: 300),
        .init(title: "A", count: 3)
    ]

    public init(store: StoreOf<StorageBox>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text("보관함")
                        .font(weight: .bold, semantic: .base1)
                    
                    Spacer()
                    
                    DesignSystemKitAsset.Icons.icFloderFilled
                        .swiftUIImage
                        .resizable()
                        .frame(width: 24, height: 24)
                        .onTapGesture {
                            newFolderPopupIsPresented = true
                        }
                }
                .padding(.horizontal, 20)
                .frame(height: 48)
                
                ScrollView {
                    VStack(spacing: 20) {
                        StorageBoxSection(
                            storageBoxList: defaultFolders,
                            onSelect: { index in
                                print("tap defaultFolders \(index) ")
                                store.send(.storageBoxTapped)
                            })
                        StorageBoxSection(
                            storageBoxList: customFolders,
                            onSelect: { index in
                                print("tap customFolders \(index) ")
                            })
                    }
                }
                .padding(.vertical, 20)
            }
            .background(DesignSystemKitAsset.Colors.g1.swiftUIColor)
            .onAppear { store.send(.onAppear) }
            .newFolderPopup(isPresented: $newFolderPopupIsPresented, list: (defaultFolders + customFolders), onComplete: { newFolderName in
                self.customFolders.append(.init(title: newFolderName, count: 0))
            })
        }
    }
}
extension View {
    func newFolderPopup(isPresented: Binding<Bool>, list: [StorageBoxModel]?, onComplete: @escaping (String) -> Void) -> some View {
        modifier(NewFolderPopupModifier(isPresented: isPresented, list: list, onComplete: onComplete))
    }
}
struct NewFolderPopupModifier: ViewModifier {
    @Binding var isPresented: Bool
    @State var newFolderName: String = ""
    let duplicatedCheckList: [StorageBoxModel]
    let onComplete: (String) -> Void
    
    init(isPresented: Binding<Bool>, list: [StorageBoxModel]?, onComplete: @escaping (String) -> Void) {
        self._isPresented = isPresented
        self.duplicatedCheckList = list ?? []
        self.onComplete = onComplete
    }
    
    func body(content: Content) -> some View {
        
        content
            .popup(isPresented: $isPresented, content: {
                LKTextFieldPopup(headerText: "새 폴더 추가",
                                 text: $newFolderName,
                                 fieldText: "폴더명",
                                 placeholder: "폴더명을 입력하세요",
                                 helperText: "같은 이름의 폴더가 있어요",
                                 textLimit: 15,
                                 isWarning: isDuplicatedNameCheck(),
                                 onCancel: {
                    isPresented = false
                    newFolderName = ""
                }, confirmText: "만들기",
                                 onConfirm: {
                    if !isDuplicatedNameCheck() {
                        isPresented = false
                        onComplete(newFolderName)
                        newFolderName = ""
                    }
                })
            })
    }
    
    private func isDuplicatedNameCheck() -> Bool {
        return duplicatedCheckList.contains(where: {$0.title.lowercased() == newFolderName.lowercased()})
    }
    
}
// TODO: - 서버에서 모델 받으면 수정
struct StorageBoxModel {
    let title: String
    let count: Int
    
    init(title: String, count: Int) {
        self.title = title
        self.count = count
    }
}
struct StorageBoxSection: View {
    
    let storageBoxList: [StorageBoxModel]
    let onSelect: (Int) -> Void
    
    init(
        storageBoxList: [StorageBoxModel],
        onSelect: @escaping (Int) -> Void)
    {
        self.storageBoxList = storageBoxList
        self.onSelect = onSelect
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ForEach(storageBoxList.indices, id: \.self) { index in
                if index > 0 {
                    Divider()
                        .frame(height: 1)
                        .padding(.horizontal, 12)
                        .foregroundColor(DesignSystemKitAsset.Colors.g1.swiftUIColor)
                }
                StorageBoxItem(model: storageBoxList[index])
                    .onTapGesture {
                        onSelect(index)
                    }
                
            }
            
        }
        .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
        .cornerRadius(12, corners: .allCorners)
        .padding(.horizontal, 20)
    }
}
struct StorageBoxItem: View {
    let model: StorageBoxModel
    
    init(model: StorageBoxModel) {
        self.model = model
    }
    
    var body: some View {
        HStack {
            DesignSystemKitAsset.Icons.icFloderFilled
                .swiftUIImage
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.leading, 12)
            
            Text(model.title)
                .font(weight: .medium, semantic: .caption3)
                .foregroundStyle(DesignSystemKitAsset.Colors.g9.swiftUIColor)
            
            Spacer()
            
            Text("\(model.count)")
                .font(weight: .medium, semantic: .caption3)
                .foregroundStyle(DesignSystemKitAsset.Colors.g4.swiftUIColor)
            
            DesignSystemKitAsset.Icons.icChevronRightM
                .swiftUIImage
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.trailing, 12)
        }
        .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
        .frame(height: 52)
    }
}
