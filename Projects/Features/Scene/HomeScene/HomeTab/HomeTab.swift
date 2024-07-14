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

        public init(tabs: [Folder]) {
            self.tabs = tabs
            selectedIndex = 0
        }
    }

    public enum Action {
        case tabSelected(at: Int)
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .tabSelected(selectedIndex):
                state.selectedIndex = selectedIndex
                return .none
            }
        }
    }
}
