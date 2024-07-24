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
        }

        public fileprivate(set) var newFolderName: String = ""
        var isTextFieldWarned: Bool = false
        var isSaveButtonDisabled: Bool = true
        var sourceView: SourceView

        public init(sourceView: SourceView) {
            self.sourceView = sourceView
        }
    }

    public enum Action {
        case backButtonTapped
        case folderNameChanged(String)
        case saveButtonTapped

        case isTextFieldWarnedChanged(Bool)
        case isSaveButtonDisabledChanged(Bool)

        case routeToPreviousScreen
        case routeToHomeScreen
    }

    public init() {}

    @Dependency(\.folderAPIClient) var folderAPIClient
    @Dependency(\.postAPIClient) var postAPIClient

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
                return .run { [newFolderName = state.newFolderName, sourceView = state.sourceView] send in
                    guard let createdFolder = try await folderAPIClient
                        .postFolders([newFolderName])
                        .first(where: { $0.name == newFolderName })
                    else { return }

                    switch sourceView {
                    case .homeScene:
                        await send(.routeToHomeScreen)

                    case let .saveURLScene(url):
                        try await postAPIClient.postPosts(folderId: createdFolder.id, url: url)
                        await send(.routeToHomeScreen)
                    }
                } catch: { _, send in
                    await send(.isTextFieldWarnedChanged(true))
                    await send(.isSaveButtonDisabledChanged(true))
                }

            case let .isTextFieldWarnedChanged(isTextFieldWarned):
                state.isTextFieldWarned = isTextFieldWarned
                return .none

            case let .isSaveButtonDisabledChanged(isSaveButtonDisabled):
                state.isSaveButtonDisabled = isSaveButtonDisabled
                return .none

            default:
                return .none
            }
        }
    }
}
