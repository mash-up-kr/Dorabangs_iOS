//
//  CreateNewFolder.swift
//  CreateNewFolder
//
//  Created by 김영균 on 7/3/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Models
import Services

@Reducer
public struct CreateNewFolder {
    @ObservableState
    public struct State: Equatable {
        public enum SourceView: Equatable {
            case homeScene
            case saveURLScene(url: URL)
            case changeFolder
            case storageBox
        }

        public fileprivate(set) var newFolderName: String = ""
        var isTextFieldWarned: Bool = false
        var isSaveButtonDisabled: Bool = true
        var sourceView: SourceView
        /// 로딩 인디케이터 표시 여부
        var isLoading: Bool = false
        /// 새 폴더 만들면서 포스트 이동시킬 경우 필요한 postId
        var postId: String?

        public init(sourceView: SourceView, postId: String? = nil) {
            self.sourceView = sourceView
            self.postId = postId
        }
    }

    public enum Action {
        case backButtonTapped
        case folderNameChanged(String)
        case saveButtonTapped

        case isTextFieldWarnedChanged(Bool)
        case isSaveButtonDisabledChanged(Bool)
        case isLoadingChanged(Bool)

        case routeToPreviousScreen
        case routeToHomeScreen
        case routeToStorageBoxScene
    }

    enum ActionID: Hashable {
        case debounceSaveButton
    }

    public init() {}

    @Dependency(\.folderAPIClient) var folderAPIClient
    @Dependency(\.postAPIClient) var postAPIClient
    @Dependency(\.mainQueue) var mainQueue

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .send(.routeToPreviousScreen)

            case let .folderNameChanged(newFolderName):
                state.newFolderName = newFolderName
                state.isTextFieldWarned = false
                state.isSaveButtonDisabled = newFolderName.isEmpty
                return .none

            case .saveButtonTapped:
                state.isLoading = true
                return .run { [newFolderName = state.newFolderName, sourceView = state.sourceView, postId = state.postId ?? ""] send in
                    guard let createdFolder = try await folderAPIClient
                        .postFolders([newFolderName])
                        .first(where: { $0.name == newFolderName })
                    else {
                        await send(.isLoadingChanged(false))
                        return
                    }
                    await send(.isLoadingChanged(false))
                    switch sourceView {
                    case .homeScene:
                        try await postAPIClient.movePostFolder(postId: postId, folderId: createdFolder.id)
                        await send(.routeToHomeScreen)

                    case let .saveURLScene(url):
                        _ = try await postAPIClient.postPosts(folderId: createdFolder.id, url: url)
                        await send(.routeToHomeScreen)

                    case .changeFolder:
                        try await postAPIClient.movePostFolder(postId: postId, folderId: createdFolder.id)
                        await send(.routeToHomeScreen)

                    case .storageBox:
                        await send(.routeToStorageBoxScene)
                    }
                } catch: { _, send in
                    await send(.isTextFieldWarnedChanged(true))
                    await send(.isSaveButtonDisabledChanged(true))
                    await send(.isLoadingChanged(false))
                }
                .debounce(id: ActionID.debounceSaveButton, for: .milliseconds(500), scheduler: mainQueue)

            case let .isTextFieldWarnedChanged(isTextFieldWarned):
                state.isTextFieldWarned = isTextFieldWarned
                return .none

            case let .isSaveButtonDisabledChanged(isSaveButtonDisabled):
                state.isSaveButtonDisabled = isSaveButtonDisabled
                return .none

            case let .isLoadingChanged(isLoading):
                state.isLoading = isLoading
                return .none

            default:
                return .none
            }
        }
    }
}
