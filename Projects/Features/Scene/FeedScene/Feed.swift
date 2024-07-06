//
//  Feed.swift
//  Home
//
//  Created by 박소현 on 6/29/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct Feed {
    @ObservableState
    public struct State: Equatable {
        public let title: String

        // TODO: - 나중에 폴더 id값으로 바꿔야함
        public init(title: String) {
            self.title = title
        }
    }

    public enum Action {
        case onAppear
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .onAppear:
                .none
            }
        }
    }
}
