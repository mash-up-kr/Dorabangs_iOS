//
//  Onboarding.swift
//  Onboarding
//
//  Created by 김영균 on 7/6/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Services

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
        case routeToTabCoordinatorScreen
    }

    public init() {}

    @Dependency(\.keychainClient) var keychainClient
    @Dependency(\.onboardingClient) var onboardingClient

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
                keychainClient.setHasOnboarded(true)
                return .send(.routeToTabCoordinatorScreen)

            case .fetchKeywords:
                return .run { send in
                    await send(.fetchKeywordsResponse(Result { try await onboardingClient.getKeywords() }))
                }

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
