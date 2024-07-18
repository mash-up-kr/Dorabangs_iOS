//
//  AIClassification.swift
//  AIClassification
//
//  Created by 김영균 on 7/7/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Models

@Reducer
public struct AIClassification {
    @ObservableState
    public struct State: Equatable {
        public static let initialState = State()
        var tabs: AIClassificationTab.State?
        var cards: AIClassificationCard.State?

        public init() {}
    }

    public enum Action {
        case onAppear
        case backButtonTapped

        case tabsChanged(AIClassificationTab.State)
        case cardsChanged(AIClassificationCard.State)

        case routeToHomeScreen
        case routeToFeedScreen(feedID: String)

        case tabs(AIClassificationTab.Action)
        case cards(AIClassificationCard.Action)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let (totalCounts, customFolders) = try await aiClassificationAPIClient.getFolders()
                    let allFolder = Folder(id: "", name: "전체", type: .all, postCount: totalCounts)
                    let folders = [allFolder] + customFolders
                    await send(.tabsChanged(.init(folders: folders, selectedFolder: allFolder)))
                    await send(.cardsChanged(.init(folders: folders, selectedFolder: allFolder)))
                }

            case .backButtonTapped:
                return .send(.routeToHomeScreen)

            case let .tabs(.selectedFolderChanged(selectedFolder)):
                guard let folders = state.tabs?.folders else { return .none }
                state.cards = AIClassificationCard.State(folders: folders, selectedFolder: selectedFolder)
                return .send(.cards(.fetchAIClassificationCards))

            default:
                return .none
            }
        }
        .ifLet(\.tabs, action: \.tabs) {
            AIClassificationTab()
        }
        .ifLet(\.cards, action: \.cards) {
            AIClassificationCard()
        }
    }
}
