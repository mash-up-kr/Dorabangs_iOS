//
//  Feed.swift
//  Home
//
//  Created by 박소현 on 6/29/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Foundation
import LocalizationKit
import Models
import Services

@Reducer
public struct Feed {
    @ObservableState
    public struct State: Equatable {
        public var currentFolder: Folder
        public var pageModel = PostPageModel()
        public var cards: [Card] = []
        public var folders: [Folder] = []

        public var editFolderPopupIsPresented: Bool = false
        public var removeFolderPopupIsPresented: Bool = false
        public var toastPopupIsPresented: Bool = false
        public var cardActionSheetPresented: Bool = false
        public var editCardPopupIsPresented: Bool = false
        public var editingPostId: String?
        public var toastMessage: String = ""
        public var folderBottomSheetIsPresent = false
        public var feedViewType: FeedViewType

        public init(
            currentFolder: Folder,
            feedViewType: FeedViewType = .all
        ) {
            self.currentFolder = currentFolder
            self.feedViewType = feedViewType
        }
    }

    public enum Action: BindableAction {
        case onAppear
        case onAppearList
        case backButtonTapped
        case routeToPreviousScreen

        // MARK: Inner Business
        case fetchFolderInfo(String)
        case updateFolderInfo(Result<Folder, Error>)
        case fetchPostList(String, PostPageModel)
        case fetchPostListResult(Result<CardListModel, Error>)

        // MARK: User Action
        case tapMore
        case tapAllType
        case tapUnreadType
        case tapSortLatest
        case tapSortPast
        case tapCard(item: Card)
        case readCard(String)
        case tapCreateNewFolder
        case tapMoveFolder(folderID: String?)
        case fetchFolders
        case fetchFoldersResult(Result<FoldersModel, Error>)
        case movedFolderResult(folderName: String?)
        case routeToCreateNewFolderScene(postId: String)
        case fetchMorePostList

        case tapRemoveCard
        case tapMoveCard
        case removeCard
        case cancelRemoveCard

        case tapChangeFolderName

        case showRemoveFolderPopup
        case tapRemoveButton
        case removeFolder(String)
        case removeFolderResult
        case cancelRemoveFolder

        case removeCardResult

        case routeToChangeFolderName(String)
        case changedFolderName(Folder)

        case bookMarkButtonTapped(Int)
        case changeBookMarkStatus(Card)
        case updatedPostResult(Result<Card, Error>)
        case showModalButtonTapped(postId: String, folderId: String)

        case routeToWebScreen(url: URL, aiSummary: String?, tags: [String])
        case binding(BindingAction<State>)
    }

    public init() {}

    @Dependency(\.folderAPIClient) var folderAPIClient
    @Dependency(\.postAPIClient) var postAPIClient
    @Dependency(\.folderClient) var folderClient

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                if state.feedViewType == .unread {
                    return .send(.tapUnreadType)
                } else {
                    return .merge(.send(.fetchFolderInfo(state.currentFolder.id)), .send(.onAppearList))
                }
            case .onAppearList:
                state.pageModel.isFavorite = (state.currentFolder.type == .favorite)
                if state.pageModel.canLoadingMore() {
                    state.pageModel.isLoading = true
                    return .send(.fetchPostList(state.currentFolder.id, state.pageModel))
                }
                return .none
            case let .fetchFolderInfo(folderId):
                return .run { send in
                    await send(.updateFolderInfo(Result { try await folderAPIClient.getFolder(folderId)
                    }))
                }
            case let .updateFolderInfo(.success(folder)):
                state.currentFolder = folder
                return .none
            case .backButtonTapped:
                return .send(.routeToPreviousScreen)
            case .fetchMorePostList:
                if state.pageModel.isLoading == false, !state.pageModel.isLast {
                    state.pageModel.isLoading = true
                    return .send(.fetchPostList(state.currentFolder.id, state.pageModel))
                } else {
                    return .none
                }
            case let .fetchPostList(folderId, pageModel):
                return .run { send in
                    await send(.fetchPostListResult(Result {
                        try await
                            folderAPIClient.getFolderPosts(folderId,
                                                           pageModel.currentPage,
                                                           10,
                                                           pageModel.order.rawValue,
                                                           pageModel.isRead,
                                                           pageModel.isFavorite)
                    }))
                }
            case let .fetchPostListResult(.success(resultModel)):
                let cards = resultModel.cards.map { $0.categorized(as: folderClient.getFolderName(folderId: $0.folderId) ?? "") }
                if state.pageModel.currentPage == 1 {
                    state.cards = cards
                } else {
                    state.cards.append(contentsOf: cards)
                }
                state.pageModel.currentPage += 1
                state.pageModel.isLast = !resultModel.hasNext
                state.pageModel.isLoading = false
                return .none
            case .fetchPostListResult(.failure):
                state.pageModel.isLoading = false
                return .none
            case .tapMore:
                state.editFolderPopupIsPresented = true
                return .none
            case .tapAllType:
                if state.pageModel.isLoading == false {
                    state.pageModel.isLoading = true
                    state.pageModel.currentPage = 1
                    state.pageModel.isRead = nil
                    return .send(.fetchPostList(state.currentFolder.id, state.pageModel))
                } else {
                    return .none
                }
            case .tapUnreadType:
                if state.pageModel.isLoading == false {
                    state.pageModel.isLoading = true
                    state.pageModel.currentPage = 1
                    state.pageModel.isRead = false
                    return .send(.fetchPostList(state.currentFolder.id, state.pageModel))
                } else {
                    return .none
                }
            case .tapSortLatest:
                if state.pageModel.isLoading == false {
                    state.pageModel.isLoading = true
                    state.pageModel.order = .DESC
                    state.pageModel.currentPage = 1
                    return .send(.fetchPostList(state.currentFolder.id, state.pageModel))
                } else {
                    return .none
                }
            case .tapSortPast:
                if state.pageModel.isLoading == false {
                    state.pageModel.isLoading = true
                    state.pageModel.order = .ASC
                    state.pageModel.currentPage = 1
                    return .send(.fetchPostList(state.currentFolder.id, state.pageModel))
                } else {
                    return .none
                }
            case .tapChangeFolderName:
                state.editFolderPopupIsPresented = false
                return .send(.routeToChangeFolderName(state.currentFolder.id))
            case let .routeToChangeFolderName(currentFolderId):
                return .none
            case .changedFolderName:
                state.toastMessage = LocalizationKitStrings.FeedScene.toastMessageFolderNameChanged
                state.toastPopupIsPresented = true
                return .none
            case .showRemoveFolderPopup:
                state.removeFolderPopupIsPresented = true
                state.editFolderPopupIsPresented = false
                return .none
            case .tapRemoveButton:
                state.editFolderPopupIsPresented = false
                state.removeFolderPopupIsPresented = false
                return .send(.removeFolder(state.currentFolder.id))
            case let .removeFolder(folderId):
                return .run { send in
                    try await folderAPIClient.deleteFolder(folderId)
                    await send(.removeFolderResult)
                } catch: { _, _ in
                    // TODO: Handle error
                }
            case .removeFolderResult:
                return .none
            case .cancelRemoveFolder:
                state.editFolderPopupIsPresented = true
                state.removeFolderPopupIsPresented = false
                return .none
            case let .tapCard(item):
                guard let url = URL(string: item.urlString) else { return .none }
                let tags = item.keywords?.compactMap(\.name) ?? []
                return .merge(.send(.readCard(item.id)), .send(.routeToWebScreen(url: url, aiSummary: item.description, tags: tags)))
            case let .readCard(postId):
                return .run { send in
                    await send(.updatedPostResult(Result {
                        try await postAPIClient.readPost(postId)
                    }))
                }
            case .tapCreateNewFolder:
                if let editingPostId = state.editingPostId {
                    return .send(.routeToCreateNewFolderScene(postId: editingPostId))
                }
                return .none
            case let .tapMoveFolder(folderName):
                if let editingPostId = state.editingPostId, let folderId = state.folders.first(where: { $0.name == folderName })?.id {
                    return .run { send in
                        try await postAPIClient.movePostFolder(postId: editingPostId, folderId: folderId)
                        await send(.movedFolderResult(folderName: folderName))
                    }
                }
                return .none
            case let .movedFolderResult(folderName):
                if let editingPostId = state.editingPostId {
                    state.cards.removeAll(where: { $0.id == editingPostId })
                }
                state.editingPostId = nil
                state.folderBottomSheetIsPresent = false
                state.toastMessage = LocalizationKitStrings.HomeScene.moveCardToastMessage(folderName ?? "")
                state.toastPopupIsPresented = true
                return .send(.fetchFolderInfo(state.currentFolder.id))
            case .fetchFolders:
                return .run { send in
                    await send(.fetchFoldersResult(Result { try await
                            folderAPIClient.getFolders()
                    }))
                }
            case let .fetchFoldersResult(.success(foldersModel)):
                let currentFolderId = state.currentFolder.id
                state.folders = foldersModel.defaultFolders + foldersModel.customFolders
                state.folders.removeAll(where: { $0.type == .all || $0.type == .favorite || $0.id == currentFolderId })
                state.folderBottomSheetIsPresent = true
                return .none
            case let .bookMarkButtonTapped(index):
                return .send(.changeBookMarkStatus(state.cards[index]))
            case let .changeBookMarkStatus(post):
                return .run { send in
                    await send(.updatedPostResult(Result {
                        try await postAPIClient.isFavoritePost(post.id, !(post.isFavorite ?? true))
                    }))
                }
            case let .updatedPostResult(.success(updatedPost)):
                if let index = state.cards.firstIndex(where: { $0.id == updatedPost.id }) {
                    if state.pageModel.isRead == false, updatedPost.readAt != nil {
                        // 읽지 않은 카드 목록에서 읽은 카드 삭제
                        state.cards.removeAll(where: { $0.id == updatedPost.id })
                    } else {
                        state.cards[index] = updatedPost
                    }
                }
                return .none
            case let .showModalButtonTapped(postId, folderId):
                state.cardActionSheetPresented = true
                state.editingPostId = postId
                return .none
            case .tapRemoveCard:
                state.editCardPopupIsPresented = true
                return .none
            case .tapMoveCard:
                state.cardActionSheetPresented = false
                return .send(.fetchFolders, animation: .default)
            case .removeCard:
                if let editingPostId = state.editingPostId {
                    return .run { send in
                        try await postAPIClient.deletePost(postId: editingPostId)
                        await send(.removeCardResult)
                    } catch: { _, _ in
                        // TODO: Handle error
                    }
                }
                return .none
            case .removeCardResult:
                if let editingPostId = state.editingPostId {
                    state.cards.removeAll(where: { $0.id == editingPostId })
                }
                state.editCardPopupIsPresented = false
                state.cardActionSheetPresented = false
                state.editingPostId = nil
                state.toastMessage = LocalizationKitStrings.StorageBoxScene.deleteCompletedToastMessage
                state.toastPopupIsPresented = true
                return .send(.fetchFolderInfo(state.currentFolder.id))
            case .cancelRemoveCard:
                state.editCardPopupIsPresented = false
                state.editingPostId = nil
                return .none
            case .binding:
                return .none
            default:
                return .none
            }
        }
    }
}
