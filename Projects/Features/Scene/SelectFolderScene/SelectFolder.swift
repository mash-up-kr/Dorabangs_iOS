//
//  SelectFolder.swift
//  SelectFolder
//
//  Created by 김영균 on 7/3/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Models
import Services

@Reducer
public struct SelectFolder {
    @ObservableState
    public struct State: Equatable {
        /// 저장할 URL
        var saveURL: URL
        /// 저장할 URL의 메타데이터
        var saveURLMetadata: URLMetadata?
        /// 폴더 목록
        var folders: [Folder] = []
        /// 선택된 폴더 인덱스
        var selectedFolderIndex: Int?
        /// 저장 버튼 비활성화 여부
        var isSaveButtonDisabled: Bool = true

        public init(saveURL: URL) {
            self.saveURL = saveURL
        }
    }

    public enum Action {
        // MARK: View Action
        case onAppear
        case backButtonTapped
        case folderSelected(Int)
        case saveButtonTapped
        case createFolderButtonTapped

        // MARK: Inner Business
        case fetchFolders
        case fetchFoldersResult(Result<[Folder], Error>)
        case fetchURLMetadata
        case fetchURLMetadataResult(Result<URLMetadata, Error>)

        // MARK: Navigation Action
        case routeToPreviousScreen
        case routeToHomeScreen
        case routeToCreateNewFolderScreen(folders: [String])
    }

    public init() {}

    @Dependency(\.folderAPIClient) var folderAPIClient
    @Dependency(\.postAPIClient) var postAPIClient
    @Dependency(\.urlMetadataClient) var urlMetadataClient

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
                return .run { [folder = state.folders[folderIndex], url = state.saveURL] send in
                    try await postAPIClient.postPosts(folderId: folder.id, url: url)
                    await send(.routeToHomeScreen)
                } catch: { _, _ in
                    // TODO: error handling
                }

            case .createFolderButtonTapped:
                let folderNames = state.folders.map(\.name)
                return .send(.routeToCreateNewFolderScreen(folders: folderNames))

            case .fetchFolders:
                return .run { send in
                    await send(.fetchFoldersResult(Result { try await folderAPIClient.getFolders() }))
                }

            case let .fetchFoldersResult(.success(folders)):
                state.folders = folders.filter { !$0.id.isEmpty }
                return .none

            case .fetchFoldersResult(.failure):
                return .none

            case .fetchURLMetadata:
                return .run { [url = state.saveURL] send in
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
