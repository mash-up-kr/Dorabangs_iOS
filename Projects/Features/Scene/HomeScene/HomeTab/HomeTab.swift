//
//  HomeTab.swift
//  Home
//
//  Created by 안상희 on 7/14/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Models

@Reducer
public struct HomeTab {
    @ObservableState
    public struct State: Equatable {
        private(set) var tabs: [Folder]
        fileprivate(set) var selectedIndex: Int
        fileprivate(set) var selectedFolderId: String?

        public init(tabs: [Folder]) {
            self.tabs = tabs
            selectedIndex = 0
        }
    }

    public enum Action {
        case tabSelected(at: Int)

        case setSelectedFolderId(folderId: String)
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .tabSelected(selectedIndex):
                state.selectedIndex = selectedIndex
                // TODO: 1) 상위코어로 선택된 FolderId 넘기기
                let folderId = state.tabs[selectedIndex].id
                return .run { send in
                    await send(.setSelectedFolderId(folderId: folderId))
                }

            case let .setSelectedFolderId(folderId: folderId):
                state.selectedFolderId = folderId
                return .none
            }
        }
    }
}
