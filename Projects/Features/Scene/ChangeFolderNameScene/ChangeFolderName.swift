//
//  ChangeFolderName.swift
//  StorageBox
//
//  Created by 박소현 on 7/7/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct ChangeFolderName {
    @ObservableState
    public struct State: Equatable {
        public static let initialState = State(folders: [])

        var folders: [String]
        var newFolderName: String = ""
        var isTextFieldWarned: Bool = false
        var isSaveButtonDisabled: Bool = true

        public init(folders: [String]) {
            self.folders = folders
        }
    }

    public enum Action {
        case backButtonTapped
        case folderNameChanged(String)
        case saveButtonTapped
        case routeToPreviousScreen
        case routeToStorageBox(String)
    }

    public init() {}

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
                    return .send(.routeToStorageBox(state.newFolderName))
                }

            default:
                return .none
            }
        }
    }
}
