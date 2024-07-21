//
//  CreateNewFolder.swift
//  CreateNewFolder
//
//  Created by 김영균 on 7/3/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Foundation

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
        case routeToPreviousScreen
        case routeToHomeScreen
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
                    return .send(.routeToHomeScreen)
                }

            default:
                return .none
            }
        }
    }
}
