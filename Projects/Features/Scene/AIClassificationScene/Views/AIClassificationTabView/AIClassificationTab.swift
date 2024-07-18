//
//  AIClassificationTab.swift
//  AIClassification
//
//  Created by 김영균 on 7/8/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Models

@Reducer
public struct AIClassificationTab {
    @ObservableState
    public struct State: Equatable {
        fileprivate(set) var folders: [Folder]
        fileprivate(set) var selectedFolder: Folder

        public init(folders: [Folder], selectedFolder: Folder) {
            self.folders = folders
            self.selectedFolder = selectedFolder
        }
    }

    public enum Action {
        case selectedFolderChanged(selectedFolder: Folder)
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .selectedFolderChanged(selectedFolder):
                state.selectedFolder = selectedFolder
                return .none
            }
        }
    }
}
