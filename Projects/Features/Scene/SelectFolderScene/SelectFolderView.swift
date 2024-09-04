//
//  SelectFolderView.swift
//  SelectFolder
//
//  Created by 김영균 on 7/3/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import LocalizationKit
import Models
import SwiftUI

public struct SelectFolderView: View {
    @Bindable private var store: StoreOf<SelectFolder>

    public init(store: StoreOf<SelectFolder>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 0) {
            LKTextMiddleTopBar(
                title: LocalizationKitStrings.SelectFolderScene.selectFolderViewNavigationTitle,
                backButtonAction: { store.send(.backButtonTapped) }
            )

            VStack(spacing: 0) {
                URLMetadataView(store: store)

                FolderListView(
                    folders: store.folders,
                    selectedIndex: $store.selectedFolderIndex.sending(\.folderSelected),
                    onSelectNewFolder: { store.send(.createFolderButtonTapped) }
                )

                Spacer()

                RoundedButton(
                    title: LocalizationKitStrings.SelectFolderScene.selectFolderViewSaveButtonTitle,
                    isDisabled: store.isSaveButtonDisabled,
                    action: { store.send(.saveButtonTapped) }
                )
                .padding(20)
            }
            .applyIf(store.isLoading, apply: { view in
                view
                    .disabled(store.isLoading)
                    .overlay(LoadingIndicator())
            })
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

private struct URLMetadataView: View {
    let urlString: String?
    let thumbnail: Data?
    let title: String?

    init(store: StoreOf<SelectFolder>) {
        urlString = store.saveURLMetadata?.url.absoluteString
        thumbnail = store.saveURLMetadata?.thumbnail
        title = store.saveURLMetadata?.title
    }

    var body: some View {
        HStack(spacing: 0) {
            descriptionView
            thumbnailView
        }
        .padding(.all, 20)
        .frame(height: 120)
        .background(DesignSystemKitAsset.Colors.g1.swiftUIColor)
    }

    var thumbnailView: some View {
        Group {
            if let thumbnail, let uiImage = UIImage(data: thumbnail) {
                Image(uiImage: uiImage)
                    .resizable()

            } else {
                DesignSystemKitAsset.Images.imgThumbnail.swiftUIImage
                    .resizable()
            }
        }
        .aspectRatio(contentMode: .fit)
        .frame(width: 80, height: 80)
        .cornerRadius(4, corners: .allCorners)
    }

    var descriptionView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title ?? "")
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.leading)
                .font(weight: .bold, semantic: .caption3)
                .foregroundStyle(DesignSystemKitAsset.Colors.g8.swiftUIColor)
                .frame(height: 44)

            Text(urlString ?? "")
                .lineLimit(1)
                .truncationMode(.tail)
                .font(weight: .regular, semantic: .s)
                .foregroundStyle(DesignSystemKitAsset.Colors.g5.swiftUIColor)
                .frame(height: 20)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 80)
    }
}

private struct FolderListView: View {
    let folders: [Folder]
    @Binding var selectedIndex: Int?
    let onSelectNewFolder: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                NewFolderView()
                    .background(Rectangle().fill(Color.clear).contentShape(.rect))
                    .onTapGesture(perform: onSelectNewFolder)
                    .padding(.horizontal, 16)

                FolderList(folders: folders.map(\.name), selectedIndex: $selectedIndex)
            }
        }
    }
}
