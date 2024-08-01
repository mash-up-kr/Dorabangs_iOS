//
//  Home.swift
//  Home
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Models
import Services

@Reducer
public struct Home {
    @ObservableState
    public struct State: Equatable {
        public var cardList: [String] = []
        public static let initialState = State()
        var bannerList: [HomeBanner] = [
            .init(
                bannerType: HomeBannerType.onboarding,
                prefix: HomeBannerType.onboarding.prefix,
                buttonTitle: HomeBannerType.onboarding.buttonTitle,
                count: 0
            )
        ]
        var selectedBannerType: HomeBannerType = .unread
        var bannerIndex: Int = 0
        var aiLinkCount = 0
        var unreadLinkCount = 0

        var tabs: HomeTab.State?
        var cards: HomeCard.State?

        /// 모달, 토스트 바텀시트 등 화면 덮는 컴포넌트 상태
        var overlayComponent = HomeOverlayComponent.State()

        public init() {}
    }

    public enum Action {
        case onAppear

        // MARK: Inner Business
        case fetchAILinkCount
        case fetchUnReadLinkCount
        case fetchData
        case fetchFolderList
        case updateBannerList
        case updateBannerPageIndicator(Int)
        case updateBannerType(HomeBannerType)
        case updateCardList

        case setAILinkCount(Int)
        case setUnReadLinkCount(Int)
        case setCardList([Card], FolderType)
        case setFolderList([Folder])
        case showErrorToast

        // MARK: User Action
        case addLinkButtonTapped
        case bannerButtonTapped(HomeBannerType)

        // MARK: Child Action
        case overlayComponent(HomeOverlayComponent.Action)
        case tabs(HomeTab.Action)
        case cards(HomeCard.Action)

        // MARK: Navigation Action
        case routeToSelectFolder(URL)
        case routeToAIClassificationScreen
        case routeToUnreadFeed
        case routeToWebScreen(URL)
        case routeToSaveURLVideoGuideScreen
    }

    public init() {}

    @Dependency(\.aiClassificationAPIClient) var aiClassificationAPIClient
    @Dependency(\.folderClient) var folderClient
    @Dependency(\.folderAPIClient) var folderAPIClient
    @Dependency(\.postAPIClient) var postAPIClient

    public var body: some ReducerOf<Self> {
        Scope(state: \.overlayComponent, action: \.overlayComponent) {
            HomeOverlayComponent()
        }
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.fetchData)

            case .fetchAILinkCount:
                return .run { send in
                    try await handleAIClassificationCount(send: send)
                }

            case .fetchUnReadLinkCount:
                return .run { send in
                    try await handleUnreadLinkCount(send: send)
                }

            case .fetchData:
                return .concatenate(
                    .send(.fetchFolderList),
                    .send(.fetchAILinkCount),
                    .send(.fetchUnReadLinkCount),
                    .send(.updateBannerList),
                    .send(.updateCardList)
                )

            case .fetchFolderList:
                return .run { send in
                    try await handleFolderList(send: send)
                }

            case .updateBannerList:
                state.bannerList = []

                if state.aiLinkCount > 0 {
                    let bannerType = HomeBannerType.ai
                    state.bannerList = [
                        .init(
                            bannerType: bannerType,
                            prefix: bannerType.prefix,
                            buttonTitle: bannerType.buttonTitle,
                            count: state.aiLinkCount
                        )
                    ]
                    state.selectedBannerType = bannerType
                }

                if state.unreadLinkCount > 0 {
                    let bannerType = HomeBannerType.unread
                    state.bannerList.append(
                        .init(
                            bannerType: bannerType,
                            prefix: bannerType.prefix,
                            buttonTitle: bannerType.buttonTitle,
                            count: state.unreadLinkCount
                        )
                    )

                    if state.bannerList.isEmpty {
                        state.selectedBannerType = bannerType
                    }
                }

                let bannerType = HomeBannerType.onboarding
                state.bannerList.append(
                    .init(
                        bannerType: bannerType,
                        prefix: bannerType.prefix,
                        buttonTitle: bannerType.buttonTitle,
                        count: 0
                    )
                )

                if state.bannerList.isEmpty {
                    state.selectedBannerType = bannerType
                }
                return .none

            case let .updateBannerPageIndicator(index):
                state.bannerIndex = index

                let banner = state.bannerList[index]
                state.selectedBannerType = banner.bannerType

                return .none

            case let .updateBannerType(bannerType):
                state.selectedBannerType = bannerType
                return .none

            case .updateCardList:
                return .run { send in
                    try await fetchAllCardList(send: send)
                }

            case let .setAILinkCount(count):
                state.aiLinkCount = count
                return .none

            case let .setUnReadLinkCount(count):
                state.unreadLinkCount = count
                return .none

            case let .setCardList(cardList, folderType):
                if folderType == .favorite {
                    let favoriteCard = cardList.filter { $0.isFavorite ?? false }
                    state.cards = HomeCard.State(cards: favoriteCard)
                } else {
                    state.cards = HomeCard.State(cards: cardList)
                }
                return .none

            case let .setFolderList(folderList):
                var receivedFolderList = folderList
                for index in 0 ..< folderList.count {
                    if folderList[index].type == .all {
                        receivedFolderList[index].id = "all"
                    } else if folderList[index].type == .favorite {
                        receivedFolderList[index].id = "favorite"
                    }
                }
                state.tabs = HomeTab.State(tabs: receivedFolderList)

                let folderDictionary: [String: String] = receivedFolderList.reduce(into: [String: String]()) { dict, folder in
                    dict[folder.id] = folder.name
                }
                folderClient.setFolderList(folderDictionary) // TODO: 실패했을 경우 처리 필요
                return .none

            case .showErrorToast:
                // TODO: Show ErrorToast
                return .none

            case .addLinkButtonTapped:
                // TODO: 링크 추가 버튼 탭 동작 구현
                return .none

            case let .bannerButtonTapped(bannerType):
                if bannerType == .ai {
                    return .send(.routeToAIClassificationScreen)
                } else if bannerType == .onboarding {
                    return .send(.routeToSaveURLVideoGuideScreen)
                } else {
                    return .send(.routeToUnreadFeed)
                }
                return .none

            case let .tabs(.tabSelected(index)):
                return .none

            case let .tabs(.setSelectedFolderId(folderId: folderId)):
                if folderId == "all" {
                    return .run { send in
                        try await handleCardList(send: send, folderId: "", folderType: .all)
                    }
                } else if folderId == "favorite" {
                    return .run { send in
                        try await handleCardList(send: send, folderId: "", folderType: .favorite)
                    }
                } else {
                    return .run { send in
                        try await handleCardList(send: send, folderId: folderId, folderType: .custom)
                    }
                }

            case let .cards(.cardTapped(item)):
                guard let url = URL(string: item.urlString) else { return .none }
                return .send(.routeToWebScreen(url))

            case let .cards(.showModalButtonTapped(postId: postId, folderId: folderId)):
                return .concatenate(
                    .send(.overlayComponent(.set(\.postId, postId))),
                    .send(.overlayComponent(.set(\.isCardActionSheetPresented, true)))
                )
                
            case .overlayComponent(.cardDeleted):
                return .send(.onAppear)

            default:
                return .none
            }
        }
        .ifLet(\.tabs, action: \.tabs) {
            HomeTab()
        }
        .ifLet(\.cards, action: \.cards) {
            HomeCard()
        }
    }
}

private extension Home {
    private func handleUnreadLinkCount(send: Send<Home.Action>) async throws {
        let unreadLinkCount = try await postAPIClient.getPostsCount(isRead: false)
        await send(.setUnReadLinkCount(unreadLinkCount))
    }

    private func handleAIClassificationCount(send: Send<Home.Action>) async throws {
        let aiClassificationCount = try await aiClassificationAPIClient.getAIClassificationCount()

        await send(.setAILinkCount(aiClassificationCount))
    }

    private func handleFolderList(send: Send<Home.Action>) async throws {
        let folderList = try await folderAPIClient.getFolders()

        if folderList.defaultFolders.isEmpty, folderList.customFolders.isEmpty {
            await send(.showErrorToast)
        } else {
            await send(.setFolderList(folderList.defaultFolders + folderList.customFolders))
        }
    }

    private func handleCardList(send: Send<Home.Action>, folderId: String, folderType: FolderType) async throws {
        let cardListModel = try await folderAPIClient.getFolderPosts(
            folderId,
            nil,
            nil,
            nil,
            nil
        )

        await send(.setCardList(cardListModel.cards, folderType))
    }

    private func fetchAllCardList(send: Send<Home.Action>) async throws {
        let cardList = try await postAPIClient.getPosts(
            page: nil,
            limit: nil,
            order: nil,
            favorite: nil
        )

        await send(.setCardList(cardList, .all))
    }
}
