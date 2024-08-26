//
//  ChangeFolder.swift
//  ChangeFolder
//
//  Created by 김영균 on 8/25/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Models
import Services

@Reducer
public struct ChangeFolder {
    @ObservableState
    public struct State: Equatable {
        /// 폴더를 변경할 URL의 ID
        var postId: String
        /// 폴더를 변경할 URL
        var url: URL
        /// 폴더를 변경할 URL의 메타데이터
        var saveURLMetadata: URLMetadata?
        /// 폴더 목록
        var folders: [Folder] = []
        /// 선택된 폴더 인덱스
        var selectedFolderIndex: Int?
        /// 저장 버튼 비활성화 여부
        var isSaveButtonDisabled: Bool = true
        /// 로딩 인디케이터 표시 여부
        var isLoading: Bool = false

        public init(postId: String, url: URL) {
            self.postId = postId
            self.url = url
        }
    }

    public enum Action {
        // MARK: View Action
        case onAppear
        case backButtonTapped
        case folderSelected(Int?)
        case saveButtonTapped
        case createFolderButtonTapped
        case isLoadingChanged(Bool)

        // MARK: Inner Business
        case fetchFolders
        case fetchFoldersResult(Result<FoldersModel, Error>)
        case fetchURLMetadata
        case fetchURLMetadataResult(Result<URLMetadata, Error>)

        // MARK: Navigation Action
        case routeToPreviousScreen
        case routeToHomeScreen
        case routeToCreateNewFolderScreen(postId: String)
    }

    enum ActionID: Hashable {
        case debounceSaveButton
    }

    public init() {}

    @Dependency(\.folderAPIClient) var folderAPIClient
    @Dependency(\.postAPIClient) var postAPIClient
    @Dependency(\.urlMetadataClient) var urlMetadataClient
    @Dependency(\.mainQueue) var mainQueue

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .merge(.send(.fetchFolders), .send(.fetchURLMetadata))

            case .backButtonTapped:
                return .send(.routeToPreviousScreen)

            case let .folderSelected(index):
                state.selectedFolderIndex = index
                state.isSaveButtonDisabled = false
                return .none

            case .saveButtonTapped:
                guard let folderIndex = state.selectedFolderIndex else { return .none }
                state.isLoading = true
                return .run { [postId = state.postId, folderId = state.folders[folderIndex].id] send in
                    try await postAPIClient.movePostFolder(postId: postId, folderId: folderId)
                    await send(.isLoadingChanged(false))
                    await send(.routeToHomeScreen)
                } catch: { _, _ in
                    // TODO: error handling
                }
                .debounce(id: ActionID.debounceSaveButton, for: .milliseconds(500), scheduler: mainQueue)

            case .createFolderButtonTapped:
                return .send(.routeToCreateNewFolderScreen(postId: state.postId))

            case let .isLoadingChanged(isLoading):
                state.isLoading = isLoading
                return .none

            case .fetchFolders:
                return .run { send in
                    await send(.fetchFoldersResult(Result { try await folderAPIClient.getFolders() }))
                }

            case let .fetchFoldersResult(.success(foldersModel)):
                state.folders = foldersModel.defaultFolders.filter { !$0.id.isEmpty } + foldersModel.customFolders.filter { !$0.id.isEmpty }
                if let defaultIndex = state.folders.firstIndex(where: { $0.type == .default }) {
                    state.selectedFolderIndex = defaultIndex
                    state.isSaveButtonDisabled = false
                }
                return .none

            case .fetchFoldersResult(.failure):
                return .none

            case .fetchURLMetadata:
                return .run { [url = state.url] send in
                    await send(.fetchURLMetadataResult(Result { try await urlMetadataClient.fetchMetadata(url) }))
                }

            case let .fetchURLMetadataResult(.success(metadata)):
                state.saveURLMetadata = metadata
                return .none

            case .fetchURLMetadataResult(.failure):
                return .none

            default:
                return .none
            }
        }
    }
}
