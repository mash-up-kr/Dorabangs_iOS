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

                    DesignSystemKitAsset.Icons.icAddFolder
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
                                store.send(.storageBoxTapped(section: 0, folderID: index), animation: .default)
                            },
                            onEdit: { index in
                                store.send(.storageBoxTapped(section: 0, folderID: index), animation: .default)
                            },
                            moreIcon: DesignSystemKitAsset.Icons.icChevronRightMedium.swiftUIImage
                        )
                        StorageBoxSection(
                            storageBoxList: store.customFolders,
                            onSelect: { folderID in
                                store.send(.storageBoxTapped(section: 1, folderID: folderID), animation: .default)
                            },
                            onEdit: { folderID in
                                store.send(.onEdit(folderID: folderID), animation: .default)
                            },
                            moreIcon: DesignSystemKitAsset.Icons.icMoreGray.swiftUIImage
                        )

                        Spacer().frame(height: 60)
                    }
                }
                .padding(.vertical, 20)
            }
            .navigationBarHidden(true)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .background(DesignSystemKitAsset.Colors.g1.swiftUIColor)
            .onAppear { store.send(.onAppear) }
        }
    }
}

extension View {
    func editFolderPopup(isPresented: Binding<Bool>, onSelect: @escaping (Int) -> Void) -> some View {
        modifier(EditFolderPopupModifier(isPresented: isPresented, onSelect: { index in
            onSelect(index)
        }))
    }

    func removeFolderPopup(onCancel: @escaping () -> Void, onRemove: @escaping () -> Void) -> some View {
        LKModal(title: "폴더 삭제", content: "폴더를 삭제하면 모든 데이터가 영구적으로\n삭제되어 복구할 수 없어요.\n그래도 삭제하시겠어요?", leftButtonTitle: "취소", leftButtonAction: {
            onCancel()
        }, rightButtonTitle: "삭제", rightButtonAction: {
            onRemove()
        })
    }
}
