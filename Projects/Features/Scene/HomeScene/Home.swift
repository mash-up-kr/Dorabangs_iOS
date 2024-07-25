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
        case setCardList([Card])
        case setFolderList([Folder])
        case showErrorToast

        // MARK: User Action
        case addLinkButtonTapped
        case bannerButtonTapped(HomeBannerType)
        case showModalButtonTapped(Int)

        // MARK: Child Action
        case overlayComponent(HomeOverlayComponent.Action)
        case tabs(HomeTab.Action)
        case cards(HomeCard.Action)

        // MARK: Navigation Action
        case routeToSelectFolder(URL)
        case routeToAIClassificationScreen
        case routeToSaveURLVideoGuideScreen
    }

    public init() {}

    @Dependency(\.folderAPIClient) var folderAPIClient
    @Dependency(\.postAPIClient) var postAPIClient

    public var body: some ReducerOf<Self> {
        Scope(state: \.overlayComponent, action: \.overlayComponent) {
            HomeOverlayComponent()
        }
        Reduce { state, action in
            switch action {
            case .onAppear:
//                let home = [
//                    Folder(id: "", name: "모든 링크", type: .all, postCount: 0),
//                    Folder(id: "", name: "즐겨찾기", type: .favorite, postCount: 0),
//                    Folder(id: "", name: "나중에 읽을 링크", type: .default, postCount: 0)
//                ]
//                state.tabs = HomeTab.State(tabs: home)
                state.cards = HomeCard.State(cards: [])
                return .run { send in
                    await send(.fetchData)
                }

            case .fetchAILinkCount:
                state.aiLinkCount = 1
                return .none

            case .fetchUnReadLinkCount:
                state.unreadLinkCount = 0
                return .none

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

            case let .setCardList(cardList):
                state.cards = HomeCard.State(cards: cardList)
                return .none

            case let .setFolderList(folderList):
                state.tabs = HomeTab.State(tabs: folderList)
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
                }
                // TODO: 배너 버튼 클릭 시 동작 구현
                print("Banner Type \(bannerType) 탭 됐어요~")
                return .none

            case let .showModalButtonTapped(index):
                return HomeOverlayComponent()
                    .reduce(into: &state.overlayComponent, action: .binding(.set(\.isCardActionSheetPresented, true)))
                    .map(Action.overlayComponent)

            case let .tabs(.tabSelected(index)):
                return .none

            case let .tabs(.setSelectedFolderId(folderId: folderId)):
                return .run { send in
                    try await handleCardList(send: send, folderId: folderId)
                }

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
    private func handleFolderList(send: Send<Home.Action>) async throws {
        let folderList = try await folderAPIClient.getFolders()

        if folderList.defaultFolders.isEmpty, folderList.customFolders.isEmpty {
            await send(.showErrorToast)
        } else {
            await send(.setFolderList(folderList.defaultFolders + folderList.customFolders))
        }
    }

    private func handleCardList(send: Send<Home.Action>, folderId: String) async throws {
        let cardListModel = try await folderAPIClient.getFolderPosts(
            folderId,
            nil,
            nil,
            nil,
            nil
        )

        await send(.setCardList(cardListModel.cards))
    }

    private func fetchAllCardList(send: Send<Home.Action>) async throws {
        let cardList = try await postAPIClient.getPosts(
            page: nil,
            limit: nil,
            order: nil,
            favorite: nil
        )

        await send(.setCardList(cardList))
    }
}
