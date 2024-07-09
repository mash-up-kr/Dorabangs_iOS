//
//  Onboarding.swift
//  Onboarding
//
//  Created by 김영균 on 7/6/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct Onboarding {
    @ObservableState
    public struct State: Equatable {
        public static let initialState = State()
        public var keywords: [String] = []
        public var selectedKeywords: Set<String> = []
        public var isCompleteButtonDisabled: Bool = true

        public init() {}
    }

    public enum Action {
        // MARK: User Action
        case onAppear
        case keywordSelected(keyword: String)
        case completeButtonTapped

        // MARK: Inner Business
        case fetchKeywords
        case fetchKeywordsResponse(Result<[String], Error>)

        // MARK: Navigation Action
        case routeToTabCoordinator
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.fetchKeywords)

            case let .keywordSelected(keyword):
                if state.selectedKeywords.contains(keyword) {
                    state.selectedKeywords.remove(keyword)
                } else {
                    state.selectedKeywords.insert(keyword)
                }
                state.isCompleteButtonDisabled = state.selectedKeywords.isEmpty
                return .none

            case .completeButtonTapped:
                return .send(.routeToTabCoordinator)

            case .fetchKeywords:
                return .none

            case let .fetchKeywordsResponse(.success(keywords)):
                state.keywords = keywords
                return .none

            case .fetchKeywordsResponse(.failure):
                return .none

            default:
                return .none
            }
        }
    }
}
