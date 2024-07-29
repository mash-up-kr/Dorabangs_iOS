//
//  Feed.swift
//  Home
//
//  Created by 박소현 on 6/29/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Models
import Services

@Reducer
public struct Feed {
    @ObservableState
    public struct State: Equatable {
        public var currentFolder: Folder
        public var pageModel = PostPageModel()
        public var cards: [Card] = []

        public var editFolderPopupIsPresented: Bool = false
        public var removeFolderPopupIsPresented: Bool = false
        public var toastPopupIsPresented: Bool = false

        public init(currentFolder: Folder) {
            self.currentFolder = currentFolder
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
        case readCardResult(Result<Card, Error>)

        case tapChangeFolderName

        case showRemoveFolderPopup
        case tapRemoveButton
        case removeFolder(String)
        case removeFolderResult
        case cancelRemoveFolder

        case routeToChangeFolderName(String)
        case changedFolderName(Folder)

        case bookMarkButtonTapped(Int)
        case changeBookMarkStatus(Card)
        case updatedPostResult(Result<Card, Error>)
        case showModalButtonTapped(Int)

        case routeToWebScreen(URL)
        case binding(BindingAction<State>)
    }

    public init() {}

    @Dependency(\.folderAPIClient) var folderAPIClient
    @Dependency(\.postAPIClient) var postAPIClient

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .merge(.send(.fetchFolderInfo(state.currentFolder.id)), .send(.onAppearList))
            case .onAppearList:
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
            case let .fetchPostList(folderId, pageModel):
                return .run { send in
                    await send(.fetchPostListResult(Result {
                        try await
                            folderAPIClient.getFolderPosts(folderId: folderId,
                                                           page: pageModel.currentPage,
                                                           limit: 10,
                                                           order: pageModel.order.rawValue,
                                                           isRead: pageModel.isRead)
                    }))
                }
            case let .fetchPostListResult(.success(resultModel)):
                if state.pageModel.currentPage == 1 {
                    state.cards = resultModel.cards
                } else {
                    state.cards.append(contentsOf: resultModel.cards)
                }
                state.pageModel.currentPage += 1
                state.pageModel.isLast = !resultModel.hasNext
                state.pageModel.isLoading = false
                return .none
            case let .fetchPostListResult(.failure(error)):
                state.pageModel.isLoading = false
                return .none
            case .tapMore:
                state.editFolderPopupIsPresented = true
                return .none
            case .tapAllType:
                state.pageModel.isLoading = true
                state.pageModel.currentPage = 1
                state.pageModel.isRead = nil
                return .send(.fetchPostList(state.currentFolder.id, state.pageModel))
            case .tapUnreadType:
                state.pageModel.isLoading = true
                state.pageModel.currentPage = 1
                state.pageModel.isRead = false
                return .send(.fetchPostList(state.currentFolder.id, state.pageModel))
            case .tapSortLatest:
                state.pageModel.isLoading = true
                state.pageModel.order = .DESC
                state.pageModel.currentPage = 1
                return .send(.fetchPostList(state.currentFolder.id, state.pageModel))
            case .tapSortPast:
                state.pageModel.isLoading = true
                state.pageModel.order = .ASC
                state.pageModel.currentPage = 1
                return .send(.fetchPostList(state.currentFolder.id, state.pageModel))
            case .tapChangeFolderName:
                state.editFolderPopupIsPresented = false
                return .send(.routeToChangeFolderName(state.currentFolder.id))
            case let .routeToChangeFolderName(currentFolderId):
                return .none
            case let .changedFolderName(newName):
                // TODO: - 통신탄 결과로 수정해야함~
//                state.title = newName
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
                return .merge(.send(.readCard(item.id)), .send(.routeToWebScreen(url)))
            case let .readCard(postId):
                return .run { send in
                    await send(.updatedPostResult(Result {
                        try await postAPIClient.readPost(postId: postId)
                    }))
                }
            case let .bookMarkButtonTapped(index):
                return .send(.changeBookMarkStatus(state.cards[index]))
            case let .changeBookMarkStatus(post):
                return .run { send in
                    await send(.updatedPostResult(Result {
                        try await postAPIClient.isFavoritePost(postId: post.id, isFavorite: !(post.isFavorite ?? true))
                    }))
                }
            case let .updatedPostResult(.success(updatedPost)):
                if let index = state.cards.firstIndex(where: { $0.id == updatedPost.id }) {
                    state.cards[index] = updatedPost
                }
                return .none
            case let .showModalButtonTapped(index):
                // TODO: 카드 > 모달 버튼 탭 동작 구현
                return .none
            case .binding:
                return .none
            default:
                return .none
            }
        }
    }
}
