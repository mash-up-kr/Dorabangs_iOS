//
//  ChangeFolderName.swift
//  StorageBox
//
//  Created by 박소현 on 7/7/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Models
import Services

@Reducer
public struct ChangeFolderName {
    @ObservableState
    public struct State: Equatable {
        public static let initialState = State(folderID: "", folders: [])

        let folderID: String
        var folders: [String]
        var newFolderName: String = ""
        var isTextFieldWarned: Bool = false
        var isSaveButtonDisabled: Bool = true

        public init(folderID: String, folders: [String]) {
            self.folderID = folderID
            self.folders = folders
        }
    }

    public enum Action {
        case backButtonTapped
        case folderNameChanged(String)
        case saveButtonTapped

        case patchFolder(String, String)
        case patchFolderResult(Result<Folder, Error>)
        case routeToPreviousScreen
        case routeToStorageBox(Folder)
    }

    public init() {}

    @Dependency(\.folderAPIClient) var folderAPIClient

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                return .send(.routeToPreviousScreen)

            case let .folderNameChanged(newFolderName):
                state.newFolderName = newFolderName
                state.isTextFieldWarned = false
                state.isSaveButtonDisabled = false
                return .none

            case .saveButtonTapped:
                if state.folders.contains(state.newFolderName) {
                    state.isTextFieldWarned = true
                    state.isSaveButtonDisabled = true
                    return .none
                } else {
                    return .send(.patchFolder(state.folderID, state.newFolderName))
                }

            case let .patchFolder(folderID, newName):
                return .run { send in
                    await send(.patchFolderResult(Result { try await folderAPIClient.patchFolder(folderID, newName)
                    }))
                }

            case let .patchFolderResult(.success(folder)):
                return .send(.routeToStorageBox(folder))

            case .patchFolderResult(.failure):
                return .none

            default:
                return .none
            }
        }
    }
}
