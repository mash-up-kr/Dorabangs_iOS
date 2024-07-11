//
//  Home.swift
//  Home
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Foundation

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

        /// 클립보드 토스트 상태
        public var clipboardToast = ClipboardToastFeature.State()
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
        case updateBannerList
        case updateBannerPageIndicator(Int)
        case updateBannerType(HomeBannerType)
        case updateCardList

        case setAILinkCount(Int)
        case setUnReadLinkCount(Int)

        // MARK: User Action
        case addLinkButtonTapped
        case bannerButtonTapped(HomeBannerType)
        case bookMarkButtonTapped(Int)
        case showModalButtonTapped(Int)
        case clipboardURLChanged(URL)

        // MARK: Child Action
        case clipboardToast(ClipboardToastFeature.Action)
        case overlayComponent(HomeOverlayComponent.Action)

        // MARK: Navigation Action
        case routeToSelectFolder(URL)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Scope(state: \.clipboardToast, action: \.clipboardToast) {
            ClipboardToastFeature()
        }
        Scope(state: \.overlayComponent, action: \.overlayComponent) {
            HomeOverlayComponent()
        }
        Reduce { state, action in
            switch action {
            case .onAppear:
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
                    .send(.fetchAILinkCount),
                    .send(.fetchUnReadLinkCount),
                    .send(.updateBannerList),
                    .send(.updateCardList)
                )

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
                print("bannerType,,", bannerType)
                return .none

            case .updateCardList:
                state.cardList = ["카드"]
                return .none

            case let .setAILinkCount(count):
                state.aiLinkCount = count
                return .none

            case let .setUnReadLinkCount(count):
                state.unreadLinkCount = count
                return .none

            case .addLinkButtonTapped:
                // TODO: 링크 추가 버튼 탭 동작 구현
                return .none

            case let .bannerButtonTapped(bannerType):
                // TODO: 배너 버튼 클릭 시 동작 구현
                print("Banner Type \(bannerType) 탭 됐어요~")
                return .none

            case let .bookMarkButtonTapped(index):
                // TODO: 카드 > 북마크 버튼 탭 동작 구현
                return .none

            case let .showModalButtonTapped(index):
                return HomeOverlayComponent()
                    .reduce(into: &state.overlayComponent, action: .binding(.set(\.isCardActionSheetPresented, true)))
                    .map(Action.overlayComponent)

            case let .clipboardURLChanged(url):
                return ClipboardToastFeature()
                    .reduce(into: &state.clipboardToast, action: .presentToast(url))
                    .map(Action.clipboardToast)

            case .clipboardToast(.saveButtonTapped):
                guard let url = URL(string: state.clipboardToast.shared.urlString) else { return .none }
                return .send(.routeToSelectFolder(url))

            default:
                return .none
            }
        }
    }
}
