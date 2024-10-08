//
//  FeedView.swift
//  Feed
//
//  Created by 박소현 on 6/29/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystemKit
import Kingfisher
import LocalizationKit
import Models
import SwiftUI

public struct FeedView: View {
    @Bindable private var store: StoreOf<Feed>

    public init(store: StoreOf<Feed>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 0) {
            LKTextMiddleTopBar(
                title: store.currentFolder.name,
                backButtonAction: { store.send(.backButtonTapped) },
                rightButtonImage: (store.currentFolder.type == .custom) ? DesignSystemKitAsset.Icons.icMoreGray.swiftUIImage : nil,
                rightButtonEnabled: true,
                action: {
                    store.send(.tapMore, animation: .easeInOut)
                }
            )
            FeedHeaderTabView(
                select: { selectType in
                    switch selectType {
                    case .all:
                        store.send(.tapAllType)
                    case .unread:
                        store.send(.tapUnreadType)
                    }
                },
                selectedType: $store.feedViewType
            )

            LKDivider()

            if store.currentFolder.postCount == 0 {
                FeedEmptyView()
            } else {
                FeedContentView(store: store)
            }
        }
        .navigationBarHidden(true)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { store.send(.onAppear) }
        .cardActionPopup(isPresented: $store.cardActionSheetPresented.projectedValue, onSelect: { index in
            if index == 0 {
                store.send(.tapRemoveCard)
            } else {
                store.send(.tapMoveCard)
            }
        })
        .editFolderPopup(isPresented: $store.editFolderPopupIsPresented.projectedValue, onSelect: { index in
            if index == 0 {
                store.send(.showRemoveFolderPopup)
            } else {
                store.send(.tapChangeFolderName)
            }
        })
        .modal(isPresented: $store.removeFolderPopupIsPresented.projectedValue, content: {
            removeFolderPopup(onCancel: {
                store.send(.cancelRemoveFolder)
            }, onRemove: {
                store.send(.tapRemoveButton)
            })
        })
        .modal(isPresented: $store.editCardPopupIsPresented.projectedValue,
               content: {
                   removeCardPopup(onRemove: {
                       store.send(.removeCard)
                   }, onCancel: {
                       store.send(.cancelRemoveCard)
                   })
               })
        .bottomSheet(
            isPresented: $store.folderBottomSheetIsPresent.projectedValue,
            folders: store.folders.map(\.name),
            onSelectNewFolder: {
                store.send(.tapCreateNewFolder)
            },
            onComplete: { store.send(.tapMoveFolder(folderID: $0)) }
        )
        .toast(isPresented: $store.toastPopupIsPresented, type: .info, message: store.toastMessage, isEmbedTabbar: false)
    }
}

extension View {
    func editFolderPopup(isPresented: Binding<Bool>, onSelect: @escaping (Int) -> Void) -> some View {
        modifier(EditFolderPopupModifier(isPresented: isPresented, onSelect: { index in
            onSelect(index)
        }))
    }

    func cardActionPopup(isPresented: Binding<Bool>, onSelect: @escaping (Int) -> Void) -> some View {
        modifier(CardActionPopupModifier(isPresented: isPresented, onSelect: { index in
            onSelect(index)
        }))
    }

    func removeFolderPopup(onCancel: @escaping () -> Void, onRemove: @escaping () -> Void) -> some View {
        LKModal(
            title: LocalizationKitStrings.FeedScene.deleteFolderModalTitle,
            content: LocalizationKitStrings.FeedScene.deleteFolderModalDescription,
            leftButtonTitle: LocalizationKitStrings.FeedScene.deleteFolderModalLeftButtonTitle,
            leftButtonAction: { onCancel() },
            rightButtonTitle: LocalizationKitStrings.FeedScene.deleteFolderModalRightButtonTitle,
            rightButtonAction: { onRemove() }
        )
    }

    func removeCardPopup(onRemove: @escaping () -> Void, onCancel: @escaping () -> Void) -> some View {
        LKModal(
            title: LocalizationKitStrings.HomeScene.deleteCardModalTitle,
            content: LocalizationKitStrings.HomeScene.deleteCardModalDescription,
            leftButtonTitle: LocalizationKitStrings.FeedScene.deleteFolderModalLeftButtonTitle,
            leftButtonAction: { onCancel() },
            rightButtonTitle: LocalizationKitStrings.FeedScene.deleteFolderModalRightButtonTitle,
            rightButtonAction: { onRemove() }
        )
    }
}

public struct EditFolderPopupModifier: ViewModifier {
    @Binding var isPresented: Bool
    let onSelect: (Int) -> Void

    public init(isPresented: Binding<Bool>,
                onSelect: @escaping (Int) -> Void)
    {
        _isPresented = isPresented
        self.onSelect = onSelect
    }

    public func body(content: Content) -> some View {
        content
            .actionSheet(
                isPresented: $isPresented,
                items: [
                    .init(
                        title: LocalizationKitStrings.FeedScene.deleteFolderActionSheetItemTitle,
                        image: DesignSystemKitAsset.Icons.icDelete.swiftUIImage.resizable(),
                        style: .destructive,
                        action: { onSelect(0) }
                    ),
                    .init(
                        title: LocalizationKitStrings.FeedScene.renameFolderActionSheetItemTitle,
                        image: DesignSystemKitAsset.Icons.icNameEdit.swiftUIImage.resizable(),
                        action: { onSelect(1) }
                    )
                ]
            )
    }
}

public struct CardActionPopupModifier: ViewModifier {
    @Binding var isPresented: Bool
    let onSelect: (Int) -> Void

    public init(isPresented: Binding<Bool>,
                onSelect: @escaping (Int) -> Void)
    {
        _isPresented = isPresented
        self.onSelect = onSelect
    }

    public func body(content: Content) -> some View {
        content
            .actionSheet(
                isPresented: $isPresented,
                items: [
                    .init(
                        title: LocalizationKitStrings.HomeScene.deleteCardModalTitle,
                        image: DesignSystemKitAsset.Icons.icDelete.swiftUIImage.resizable(),
                        style: .destructive,
                        action: { onSelect(0) }
                    ),
                    .init(
                        title: LocalizationKitStrings.HomeScene.movePostActionSheetItemTitle,
                        image: DesignSystemKitAsset.Icons.icNameEdit.swiftUIImage.resizable(),
                        action: { onSelect(1) }
                    )
                ]
            )
    }
}

private func folderIcon(_ folderType: FolderType) -> Image {
    switch folderType {
    case .custom:
        DesignSystemKitAsset.Images.imgFolderBig.swiftUIImage
    case .default:
        DesignSystemKitAsset.Images.imgPinBig.swiftUIImage
    case .all:
        DesignSystemKitAsset.Images.imgAllBig.swiftUIImage
    case .favorite:
        DesignSystemKitAsset.Images.imgBookmarkBig.swiftUIImage
    }
}

struct FeedContentView: View {
    var store: StoreOf<Feed>

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                FeedSortView(
                    postCounts: store.currentFolder.postCount,
                    onSort: { sortType in
                        switch sortType {
                        case .latest:
                            store.send(.tapSortLatest)
                        case .past:
                            store.send(.tapSortPast)
                        }
                    }
                )

                LKDivider()

                ForEach(Array(store.cards.enumerated()), id: \.offset) { index, item in
                    VStack(spacing: 0) {
                        LKCard(
                            aiStatus: getStatus(item.aiStatus ?? .failure),
                            progress: 0.4,
                            title: item.title,
                            description: item.description,
                            thumbnailImage: { ThumbnailImage(urlString: item.thumbnail) },
                            tags: Array((item.keywords ?? []).prefix(3).map(\.name)),
                            category: item.category ?? store.currentFolder.name,
                            timeSince: item.createdAt.timeAgo(),
                            isFavorite: item.isFavorite ?? false,
                            bookMarkAction: { store.send(.bookMarkButtonTapped(index)) },
                            showModalAction: { store.send(.showModalButtonTapped(postId: item.id, folderId: item.folderId), animation: .easeInOut) }
                        )
                        .onTapGesture {
                            store.send(.tapCard(item: item))
                        }
                        .onAppear {
                            if item == store.cards.last {
                                store.send(.fetchMorePostList)
                            }
                        }

                        LKDivider()
                    }
                }
            }
        }
    }

    private func getStatus(_ aiStatus: AIStatus) -> LKCardAIStatus {
        switch aiStatus {
        case .success:
            .success
        case .failure:
            .failure
        case .inProgress:
            .inProgress
        }
    }
}

struct ThumbnailImage: View {
    let urlString: String?

    var body: some View {
        if let urlString, let url = URL(string: urlString) {
            KFImage(url)
                .placeholder { DesignSystemKitAsset.Images.imgThumbnail.swiftUIImage }
                .appendProcessor(DownsamplingImageProcessor(size: .init(width: 80, height: 80)))
                .scaleFactor(UIScreen.main.scale)
                .cacheOriginalImage()
                .roundCorner(radius: .point(4), roundingCorners: .all)
                .cancelOnDisappear(true)
                .resizable()
                .scaledToFill()
                .frame(width: 80, height: 80)
        } else {
            DesignSystemKitAsset.Images.imgThumbnail.swiftUIImage
                .resizable()
                .frame(width: 80, height: 80)
                .cornerRadius(4, corners: .allCorners)
        }
    }
}
