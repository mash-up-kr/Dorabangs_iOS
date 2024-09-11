//
//  Home.swift
//  Home
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Foundation
import LocalizationKit
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
        var isNavigationPushed: Bool = false
        var isaddLinkButtonShowed: Bool = true

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
        case updateCardList
        case updatePagingCardList([Card])
        case isLoadingChanged(isLoading: Bool)
        case fetchSummarizingCard([String])
        case updateNavigationStatus(Bool)

        case setAILinkCount(Int)
        case setUnReadLinkCount(Int)
        case setCardList([Card], FolderType)
        case setFolderList([Folder])
        case setMorePagingStatus(Bool)
        case setIsAddLinkButtonShowed(Bool)
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
        case routeToUnreadFeed(Folder)
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
                    async let folderListResponse = try folderAPIClient.getFolders()
                    async let aiClassificationLinkCountResponse = try aiClassificationAPIClient.getAIClassificationCount()
                    async let unreadLinkCountResponse = try postAPIClient.getPostsCount(isRead: false)
                    async let cardListResponse = try postAPIClient.getPosts(
                        page: nil,
                        limit: nil,
                        order: nil,
                        favorite: nil
                    )

                    await send(.isLoadingChanged(isLoading: true))
                    let (folderList, aiLinkCount, unreadLinkCount, cardList) = try await (
                        folderListResponse.toFolderList,
                        aiClassificationLinkCountResponse,
                        unreadLinkCountResponse,
                        cardListResponse
                    )

                    await send(.setFolderList(folderList))
                    await send(.setAILinkCount(aiLinkCount))
                    await send(.setUnReadLinkCount(unreadLinkCount))
                    await send(.updateBannerList(aiLinkCount, unreadLinkCount))
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

            case .updateCardList:
                return .run { send in
                    try await fetchAllCardList(send: send)
                }

            case let .isLoadingChanged(isLoading: isLoading):
                state.isLoading = isLoading
                return .none

            case let .updateNavigationStatus(isPushed):
                state.isNavigationPushed = isPushed
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
                // "all", "favorite", "default" 폴더를 필터링하여 상단에 유지
                let fixedFolders = receivedFolderList.filter { $0.type == .all || $0.type == .favorite || $0.type == .default }

                // 나머지 폴더들 필터링 후 postCount에 따라 정렬
                let sortedFolders = receivedFolderList
                    .filter { $0.type != .all && $0.type != .favorite && $0.type != .default }
                    .sorted {
                        // postCount 비교
                        if $0.postCount != $1.postCount {
                            return $0.postCount > $1.postCount
                        }
                        // postCount가 동일한 경우, createdAt 비교
                        if let date0 = $0.creationDate, let date1 = $1.creationDate {
                            return date0 < date1
                        }
                        return false
                    }

                // 최종 리스트: 고정된 폴더 + 정렬된 폴더
                let finalFolders = fixedFolders + sortedFolders
                state.tabs = HomeTab.State(tabs: finalFolders)

                let folderDictionary: [String: String] = finalFolders.reduce(into: [String: String]()) { dict, folder in
                    dict[folder.id] = folder.name
                }
                folderClient.setFolderList(folderDictionary) // TODO: 실패했을 경우 처리 필요
                return .none

            case let .setMorePagingStatus(morePagingNeeded):
                state.morePagingNeeded = morePagingNeeded
                return .none

            case let .setIsAddLinkButtonShowed(isShowed):
                state.isaddLinkButtonShowed = isShowed
                return .none

            case .showErrorToast:
                // TODO: Show ErrorToast
                return .none

            case .addLinkButtonTapped:
                // TODO: 링크 추가 버튼 탭 동작 구현
                return .none

            case let .banner(.bannerButtonTapped(bannerType)):
                state.isNavigationPushed = true

                if bannerType == .ai {
                    return .send(.routeToAIClassificationScreen)
                } else if bannerType == .onboarding {
                    return .send(.routeToSaveURLVideoGuideScreen)
                } else {
                    let folder = Folder(id: "", name: LocalizationKitStrings.Common.readLaterLink, type: .default, postCount: state.unreadLinkCount)
                    return .send(.routeToUnreadFeed(folder))
                }

            case let .tabs(.tabSelected(index)):
                guard let tabs = state.tabs else { return .none }
                state.cards = nil
                let folderId = tabs.selectedFolderId
                return .run { send in
                    await send(.isLoadingChanged(isLoading: true))
                    try await handleCardList(send: send, folderId: folderId)
                    await send(.isLoadingChanged(isLoading: false))
                }

            case let .cards(.cardTapped(item)):
                guard let url = URL(string: item.urlString) else { return .none }
                state.isNavigationPushed = true

                return .run { send in
                    await send(.routeToWebScreen(url))

                    if item.readAt == nil {
                        try await postAPIClient.readPost(item.id)
                    }
                }

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
                            await send(.setMorePagingStatus(false))
                            await send(.cards(.setFetchedAllCardsStatus(true)))
                        } else {
                            await send(.cards(.addItems(items: cardList)))
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
    private func handleCardList(send: Send<Home.Action>, folderId: String) async throws {
        if folderId == "all" {
            try await send(.setCardList(postAPIClient.getPosts(page: 1, limit: nil, order: nil, favorite: false), .all))
        } else if folderId == "favorite" {
            try await send(.setCardList(postAPIClient.getPosts(page: 1, limit: nil, order: nil, favorite: true), .favorite))
        } else {
            try await send(.setCardList(folderAPIClient.getFolderPosts(folderId, 1, nil, nil, nil, nil).cards, .custom))
        }
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
