//
//  HomeBannerPageControl.swift
//  Home
//
//  Created by 안상희 on 8/1/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Models

@Reducer
public struct HomeBannerPageControl {
    @ObservableState
    public struct State: Equatable {
        var bannerList: [HomeBanner] = []
        var bannerIndex: Int = 0
        var selectedBannerType: HomeBannerType?
        var aiLinkCount: Int
        var unreadLinkCount: Int

        public init(aiLinkCount: Int, unreadLinkCount: Int) {
            self.aiLinkCount = aiLinkCount
            self.unreadLinkCount = unreadLinkCount
            let (bannerList, selectedBannerType) = HomeBannerPageControl.make(aiLinkCount: aiLinkCount, unreadLinkCount: unreadLinkCount)
            self.bannerList = bannerList
            self.selectedBannerType = selectedBannerType
        }
    }

    public enum Action: BindableAction {
        case setBanner(HomeBannerType)
        case updateBannerList(Int, Int)
        case updateBannerPageIndicator(Int)
        case bannerButtonTapped(HomeBannerType)
        case binding(BindingAction<State>)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case let .setBanner(bannerType):
                state.selectedBannerType = bannerType
                return .none

            case let .updateBannerList(aiLinkCount, unreadLinkCount):
                state.bannerList = []

                return .none

            case let .updateBannerPageIndicator(index):
                state.bannerIndex = index
                state.selectedBannerType = state.bannerList[index].bannerType
                return .none

            default:
                return .none
            }
        }
    }
}

extension HomeBannerPageControl {
    static func make(aiLinkCount: Int, unreadLinkCount: Int) -> ([HomeBanner], HomeBannerType) {
        var bannerList: [HomeBanner] = []
        var selectedBannerType: HomeBannerType = .onboarding
        if aiLinkCount > 0 {
            let bannerType = HomeBannerType.ai
            bannerList = [
                .init(
                    bannerType: bannerType,
                    prefix: bannerType.prefix,
                    buttonTitle: bannerType.buttonTitle,
                    count: aiLinkCount
                )
            ]
            selectedBannerType = bannerType
        }

        if unreadLinkCount > 0 {
            let bannerType = HomeBannerType.unread
            bannerList.append(
                .init(
                    bannerType: bannerType,
                    prefix: bannerType.prefix,
                    buttonTitle: bannerType.buttonTitle,
                    count: unreadLinkCount
                )
            )

            if bannerList.isEmpty {
                selectedBannerType = bannerType
            }
        }

        let bannerType = HomeBannerType.onboarding
        bannerList.append(
            .init(
                bannerType: bannerType,
                prefix: bannerType.prefix,
                buttonTitle: bannerType.buttonTitle,
                count: 0
            )
        )

        if bannerList.isEmpty {
            selectedBannerType = bannerType
        }
        return (bannerList, selectedBannerType)
    }
}
