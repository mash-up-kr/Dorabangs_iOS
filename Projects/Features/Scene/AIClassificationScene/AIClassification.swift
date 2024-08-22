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
        // 처음 진입했을 때만 API를 호출하기 위해 ViewDidLoad 여부를 저장합니다.
        var viewDidLoad: Bool = false
        var isLoading: Bool = false
        var tabs: AIClassificationTab.State?
        var cards: AIClassificationCard.State?

        public init() {}
    }

    public enum Action {
        case onAppear
        case backButtonTapped

        case tabsChanged(AIClassificationTab.State)
        case cardsChanged(AIClassificationCard.State)
        case isLoadingChanged(isLoading: Bool)

        case routeToHomeScreen
        case routeToFeedScreen(folder: Folder)

        case tabs(AIClassificationTab.Action)
        case cards(AIClassificationCard.Action)
    }

    public init() {}

    @Dependency(\.aiClassificationAPIClient) var aiClassificationAPIClient

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                guard state.viewDidLoad == false else { return .none }
                state.viewDidLoad = true
                return .run { send in
                    await send(.isLoadingChanged(isLoading: true))

                    async let folderResponse = try aiClassificationAPIClient.getFolders()
                    async let postsResponse = try aiClassificationAPIClient.getPosts(folderId: nil, page: 1)
                    let (customFolders, totalCounts, cardListModel) = try await (folderResponse.folders, folderResponse.totalCounts, postsResponse)

                    let allFolder = Folder(id: Folder.ID.all, name: "전체", type: .all, postCount: totalCounts).toLocalized
                    let folders = [allFolder] + customFolders

                    await send(.tabsChanged(.init(folders: folders, selectedFolderIndex: 0)))
                    await send(.cardsChanged(.init(folders: folders, selectedFolderId: allFolder.id, cardList: cardListModel)))
                    await send(.isLoadingChanged(isLoading: false))
                }

            case .backButtonTapped:
                return .send(.routeToHomeScreen)

            case let .tabsChanged(tabs):
                state.tabs = tabs
                return .none

            case let .cardsChanged(cards):
                state.cards = cards
                return .none

            case let .isLoadingChanged(isLoading):
                state.isLoading = isLoading
                return .none

            case let .tabs(.selectedFolderIndexChanged(selectedFolderIndex)):
                guard let folders = state.tabs?.folders else { return .none }
                let apiSelectedFolderId = folders[selectedFolderIndex].id == Folder.ID.all ? nil : folders[selectedFolderIndex].id
                let selectedFolderId = folders[selectedFolderIndex].id
                return .run { send in
                    await send(.isLoadingChanged(isLoading: true))
                    let cardListModel = try await aiClassificationAPIClient.getPosts(folderId: apiSelectedFolderId, page: 1)
                    await send(.cardsChanged(.init(folders: folders, selectedFolderId: selectedFolderId, cardList: cardListModel)))
                    await send(.isLoadingChanged(isLoading: false))
                }

            case let .cards(.sectionsChanged(sections)):
                let folders = sections.values.elements
                return .send(.tabs(.foldersChanged(folders: folders)))

            case .cards(.routeToHomeScreen):
                return .send(.routeToHomeScreen)

            case let .cards(.routeToFeedScreen(folder)):
                return .send(.routeToFeedScreen(folder: folder))

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
