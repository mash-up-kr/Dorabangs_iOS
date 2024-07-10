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
