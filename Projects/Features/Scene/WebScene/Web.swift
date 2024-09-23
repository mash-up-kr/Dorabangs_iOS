//
//  Web.swift
//  Web
//
//  Created by 김영균 on 7/27/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Foundation

@Reducer
public struct Web {
    @ObservableState
    public struct State: Equatable {
        var url: URL
        /// 웹사이트 AI 요약
        var aiSummary: String?
        /// 웹사이트 AI 요약 태그
        var tags: [String]

        public init(url: URL, aiSummary: String? = nil, tags: [String] = []) {
            self.url = url
            self.aiSummary = aiSummary
            self.tags = tags
        }
    }

    public enum Action {
        case backButtonTapped
        case showSummaryButtonTapped
        case routeToPreviousScreen
        case routeToAISummaryScreen(aiSummary: String?, tags: [String])
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .backButtonTapped:
                .send(.routeToPreviousScreen)

            case .showSummaryButtonTapped:
                .send(.routeToAISummaryScreen(aiSummary: state.aiSummary, tags: state.tags))

            default:
                .none
            }
        }
    }
}
