//
//  StorageBoxView.swift
//  StorageBox
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import Models
import SwiftUI

public struct StorageBoxView: View {
    @Perception.Bindable private var store: StoreOf<StorageBox>

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
                            store.send(.tapNewFolderButton)
                        }
                }
                .padding(.horizontal, 20)
                .frame(height: 48)

                ScrollView {
                    VStack(spacing: 20) {
                        StorageBoxSection(
                            storageBoxList: store.defaultFolders,
                            onSelect: { index in
                                store.send(.storageBoxTapped(section: 0, index: index))
                            },
                            onEdit: { index in
                                store.send(.storageBoxTapped(section: 0, index: index))
                            }
                        )
                        StorageBoxSection(
                            storageBoxList: store.customFolders,
                            onSelect: { index in
                                store.send(.storageBoxTapped(section: 0, index: index))
                            },
                            onEdit: { index in
                                store.send(.onEdit(index: index))
                            }
                        )
                    }
                }
                .padding(.vertical, 20)
            }
            .background(DesignSystemKitAsset.Colors.g1.swiftUIColor)
            .onAppear { store.send(.onAppear) }
            .newFolderPopup(isPresented: $store.newFolderPopupIsPresented.projectedValue,
                            list: store.defaultFolders + store.customFolders, onComplete: { _ in

                            })
            .editFolderPopup(isPresented: $store.editFolderPopupIsPresented.projectedValue, onSelect: { index in
                if index == 0 {
                    store.send(.showRemoveFolderPopup, animation: .default)
                } else {
                    store.send(.routeToChangeFolderName)
                }
            })

            .modal(isPresented: $store.removeFolderPopupIsPresented.projectedValue, content: {
                LKModal(title: "폴더 삭제", content: "폴더를 삭제하면 모든 데이터가 영구적으로 삭제되어 복구할 수 없어요.\n그래도 삭제하시겠어요?", leftButtonTitle: "취소", leftButtonAction: {
                    store.send(.cancelRemoveFolder)
                }, rightButtonTitle: "삭제", rightButtonAction: {
                    store.send(.removeFolder)
                })
            })
        }
    }
}

extension View {
    func newFolderPopup(isPresented: Binding<Bool>, list: [StorageBoxModel]?, onComplete: @escaping (String) -> Void) -> some View {
        modifier(NewFolderPopupModifier(isPresented: isPresented, list: list, onComplete: onComplete))
    }

    func editFolderPopup(isPresented: Binding<Bool>, onSelect: @escaping (Int) -> Void) -> some View {
        modifier(EditFolderPopupModifier(isPresented: isPresented, onSelect: { index in
            onSelect(index)
        }))
    }
}

struct EditFolderPopupModifier: ViewModifier {
    @Binding var isPresented: Bool
    let onSelect: (Int) -> Void

    init(isPresented: Binding<Bool>,
         onSelect: @escaping (Int) -> Void)
    {
        _isPresented = isPresented
        self.onSelect = onSelect
    }

    func body(content: Content) -> some View {
        content
            .actionSheet(isPresented: $isPresented, items: [.init(title: "폴더 삭제", image: DesignSystemKitAsset.Icons.icDelete.swiftUIImage.resizable(), action: {
                onSelect(0)
            }), .init(title: "폴더 이름 변경", image: DesignSystemKitAsset.Icons.icNameEdit.swiftUIImage.resizable(), action: {
                onSelect(1)
            })])
    }
}

struct NewFolderPopupModifier: ViewModifier {
    @Binding var isPresented: Bool
    @State var newFolderName: String = ""
    let duplicatedCheckList: [StorageBoxModel]
    let onComplete: (String) -> Void

    init(isPresented: Binding<Bool>, list: [StorageBoxModel]?, onComplete: @escaping (String) -> Void) {
        _isPresented = isPresented
        duplicatedCheckList = list ?? []
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
        duplicatedCheckList.contains(where: { $0.title.lowercased() == newFolderName.lowercased() })
    }
}

struct StorageBoxSection: View {
    let storageBoxList: [StorageBoxModel]
    let onSelect: (Int) -> Void
    let onEdit: (Int) -> Void

    init(
        storageBoxList: [StorageBoxModel],
        onSelect: @escaping (Int) -> Void,
        onEdit: @escaping (Int) -> Void
    ) {
        self.storageBoxList = storageBoxList
        self.onSelect = onSelect
        self.onEdit = onEdit
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
                StorageBoxItem(
                    model: storageBoxList[index],
                    onMove: { onSelect(index) },
                    onEdit: { onEdit(index) }
                )
            }
        }
        .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
        .cornerRadius(12, corners: .allCorners)
        .padding(.horizontal, 20)
    }
}

struct StorageBoxItem: View {
    let model: StorageBoxModel
    let onMove: () -> Void
    let onEdit: () -> Void

    init(model: StorageBoxModel,
         onMove: @escaping () -> Void,
         onEdit: @escaping () -> Void)
    {
        self.model = model
        self.onMove = onMove
        self.onEdit = onEdit
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
                .onTapGesture {
                    onMove()
                }

            Spacer()

            Text("\(model.count)")
                .font(weight: .medium, semantic: .caption3)
                .foregroundStyle(DesignSystemKitAsset.Colors.g4.swiftUIColor)

            DesignSystemKitAsset.Icons.icChevronRightM
                .swiftUIImage
                .resizable()
                .frame(width: 24, height: 24)
                .padding(.trailing, 12)
                .onTapGesture {
                    onEdit()
                }
        }
        .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
        .frame(height: 52)
    }
}
