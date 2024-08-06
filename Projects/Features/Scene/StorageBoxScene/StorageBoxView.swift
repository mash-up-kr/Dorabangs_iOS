//
//  StorageBoxView.swift
//  StorageBox
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import LocalizationKit
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
                    Text(LocalizationKitStrings.StorageBoxScene.storageboxViewNavigationTitle)
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
        LKModal(
            title: LocalizationKitStrings.StorageBoxScene.deleteFolderModalTitle,
            content: LocalizationKitStrings.StorageBoxScene.deleteFolderModalDescription,
            leftButtonTitle: LocalizationKitStrings.StorageBoxScene.deleteFolderModalLeftButtonTitle,
            leftButtonAction: { onCancel() },
            rightButtonTitle: LocalizationKitStrings.StorageBoxScene.deleteFolderModalRightButtonTitle,
            rightButtonAction: { onRemove() }
        )
    }
}
