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
        public static let initialState = State()
        var selectedBannerType: HomeBannerType = .ai
        var bannerIndex: Int = 0
        var aiLinkCount = 0
        var unreadLinkCount = 0
        var isLoading: Bool = false
        var morePagingNeeded: Bool = true

        var tabs: HomeTab.State?
        var banner: HomeBannerPageControl.State?
        var cards: HomeCard.State?

        /// 모달, 토스트 바텀시트 등 화면 덮는 컴포넌트 상태
        var overlayComponent = HomeOverlayComponent.State()

        public init() {}
    }

    public enum Action {
        case onAppear

        // MARK: Inner Business
        case updateBannerList(Int, Int)
        case updateBannerPageIndicator(Int)
        case updateBannerType(HomeBannerType)
        case updateCardList
        case updatePagingCardList([Card])
        case isLoadingChanged(isLoading: Bool)
        case fetchSummarizingCard([String])

        case setAILinkCount(Int)
        case setUnReadLinkCount(Int)
        case setCardList([Card], FolderType)
        case setFolderList([Folder])
        case setMorePagingStatus(Bool)
        case showErrorToast

        // MARK: User Action
        case addLinkButtonTapped
        case bannerButtonTapped(HomeBannerType)

        // MARK: Child Action
        case overlayComponent(HomeOverlayComponent.Action)
        case tabs(HomeTab.Action)
        case banner(HomeBannerPageControl.Action)
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
                return .run { send in
                    await send(.isLoadingChanged(isLoading: true))

                    async let folderListResponse = try folderAPIClient.getFolders()
                    async let aiClassificationLinkCountResponse = try aiClassificationAPIClient.getAIClassificationCount()
                    async let unreadLinkCountResponse = try postAPIClient.getPostsCount(isRead: false)
                    async let cardListResponse = try postAPIClient.getPosts(
                        page: nil,
                        limit: nil,
                        order: nil,
                        favorite: nil
                    )

                    let folderList = try await folderListResponse.toFolderList
                    let aiLinkCount = try await aiClassificationLinkCountResponse
                    let unreadLinkCount = try await unreadLinkCountResponse
                    let cardList = try await cardListResponse

                    await send(.setFolderList(folderList))
                    await send(.setAILinkCount(aiLinkCount))
                    await send(.setUnReadLinkCount(unreadLinkCount))
                    await send(.updateBannerList(aiLinkCount, unreadLinkCount))
                    await send(.banner(.updateBannerList(aiLinkCount, unreadLinkCount)))
                    await send(.setCardList(cardList, .all))

                    await send(.isLoadingChanged(isLoading: false))

                    let summarizingCardIdList: [String] = cardList.filter { $0.aiStatus == .inProgress }.map(\.id)
                    if !summarizingCardIdList.isEmpty {
                        await send(.cards(.setSummarizingCardIdList(summarizingCardIdList)))
                    }
                }

            case let .updateBannerList(aiLinkCount, unreadLinkCount):
                state.banner = HomeBannerPageControl.State(aiLinkCount: aiLinkCount, unreadLinkCount: unreadLinkCount)
                return .none

            case let .updateBannerPageIndicator(index):
                state.bannerIndex = index

                if let bannerList = state.banner?.bannerList {
                    let selectedBannerType = bannerList[index].bannerType
                    return .send(.banner(.set(\.selectedBannerType, selectedBannerType)))
                }
                return .none

            case let .updateBannerType(bannerType):
                state.selectedBannerType = bannerType
                return .none

            case .updateCardList:
                return .run { send in
                    try await fetchAllCardList(send: send)
                }

            case let .updatePagingCardList(cardList):
                state.cards?.cards.append(contentsOf: cardList)
                return .none

            case let .isLoadingChanged(isLoading: isLoading):
                state.isLoading = isLoading
                return .none

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

            case let .setMorePagingStatus(morePagingNeeded):
                state.morePagingNeeded = morePagingNeeded
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
                        await send(.isLoadingChanged(isLoading: true))
                        try await handleCardList(send: send, folderId: "", folderType: .all)
                        await send(.isLoadingChanged(isLoading: false))
                    }
                } else if folderId == "favorite" {
                    return .run { send in
                        await send(.isLoadingChanged(isLoading: true))
                        try await handleCardList(send: send, folderId: "", folderType: .favorite)
                        await send(.isLoadingChanged(isLoading: false))
                    }
                } else {
                    return .run { send in
                        await send(.isLoadingChanged(isLoading: true))
                        try await handleCardList(send: send, folderId: folderId, folderType: .custom)
                        await send(.isLoadingChanged(isLoading: false))
                    }
                }

            case let .cards(.cardTapped(item)):
                guard let url = URL(string: item.urlString) else { return .none }
                return .send(.routeToWebScreen(url))

            case let .cards(.showModalButtonTapped(postId: postId, folderId: folderId)):
                var folderList = UserFolder.shared.list
                folderList.removeValue(forKey: "all")
                folderList.removeValue(forKey: "favorite")
                return .concatenate(
                    .send(.overlayComponent(.set(\.folderList, folderList))),
                    .send(.overlayComponent(.set(\.postId, postId))),
                    .send(.overlayComponent(.set(\.isCardActionSheetPresented, true)))
                )

            case let .cards(.fetchCards(page)):
                return .run { [state] send in
                    if state.morePagingNeeded {
                        async let cardListResponse = try postAPIClient.getPosts(
                            page: page,
                            limit: nil,
                            order: nil,
                            favorite: nil
                        )

                        let cardList = try await cardListResponse
                        if cardList.count == 0 {
                            async let _ = send(.setMorePagingStatus(false))
                            async let _ = send(.cards(.setFetchedAllCardsStatus(true)))
                        } else {
                            await send(.updatePagingCardList(cardList))
                        }
                    }
                }

            case .overlayComponent(.cardDeleted):
                return .send(.onAppear)

            case .overlayComponent(.cardMoved):
                return .send(.onAppear)

            default:
                return .none
            }
        }
        .ifLet(\.tabs, action: \.tabs) {
            HomeTab()
        }
        .ifLet(\.banner, action: \.banner) {
            HomeBannerPageControl()
        }
        .ifLet(\.cards, action: \.cards) {
            HomeCard()
        }
    }
}

private extension Home {
    private func handleCardList(send: Send<Home.Action>, folderId: String, folderType: FolderType) async throws {
        var cardList: [Card] = []
        var page = 1
        var hasNext = true

        while hasNext {
            let cardListModel = try await folderAPIClient.getFolderPosts(
                folderId,
                page,
                nil,
                nil,
                nil
            )
            hasNext = cardListModel.hasNext
            cardList.append(contentsOf: cardListModel.cards)
            page += 1
        }

        await send(.setCardList(cardList, folderType))
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
