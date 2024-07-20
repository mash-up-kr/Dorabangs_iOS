//
//  AIClassification.swift
//  AIClassification
//
//  Created by 김영균 on 7/7/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Models
import Services

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

    @Dependency(\.aiClassificationAPIClient) var aiClassificationAPIClient

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    let (totalCounts, customFolders) = try await aiClassificationAPIClient.getFolders()
                    let allFolder = Folder(id: Folder.ID.all, name: "전체", type: .all, postCount: totalCounts)
                    let folders = [allFolder] + customFolders
                    await send(.tabsChanged(.init(folders: folders, selectedFolderIndex: 0)))
                    await send(.cardsChanged(.init(folders: folders, selectedFolderId: allFolder.id)))
                }

            case .backButtonTapped:
                return .send(.routeToHomeScreen)

            case let .tabsChanged(tabs):
                state.tabs = tabs
                return .none

            case let .cardsChanged(cards):
                state.cards = cards
                return .none

            case let .tabs(.selectedFolderIndexChanged(selectedFolderIndex)):
                guard let folders = state.tabs?.folders else { return .none }
                let selectedFolderId = folders[selectedFolderIndex].id
                state.cards = AIClassificationCard.State(folders: folders, selectedFolderId: selectedFolderId)
                return .send(.cards(.fetchAIClassificationCards))

            case let .cards(.sectionsChanged(sections)):
                let folders = sections.values.elements
                return .send(.tabs(.foldersChanged(folders: folders)))

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
