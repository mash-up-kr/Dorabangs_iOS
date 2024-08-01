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
        var selectedBannerType: HomeBannerType?
        var aiLinkCount: Int
        var unreadLinkCount: Int

        public init(aiLinkCount: Int, unreadLinkCount: Int) {
            self.aiLinkCount = aiLinkCount
            self.unreadLinkCount = unreadLinkCount
        }
    }

    public enum Action: BindableAction {
        case setBanner(HomeBannerType)
        case updateBannerList(Int, Int)
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

            default:
                return .none
            }
        }
    }
}
