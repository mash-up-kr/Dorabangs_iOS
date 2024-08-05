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
        fileprivate(set) var selectedFolderIndex: Int

        public init(folders: [Folder], selectedFolderIndex: Int) {
            self.folders = folders
            self.selectedFolderIndex = selectedFolderIndex
        }
    }

    public enum Action {
        case foldersChanged(folders: [Folder])
        case selectedFolderIndexChanged(selectedFolderIndex: Int)
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .foldersChanged(folders):
                state.folders = folders
                return .none

            case let .selectedFolderIndexChanged(selectedFolderIndex):
                state.selectedFolderIndex = selectedFolderIndex
                return .none
            }
        }
    }
}
