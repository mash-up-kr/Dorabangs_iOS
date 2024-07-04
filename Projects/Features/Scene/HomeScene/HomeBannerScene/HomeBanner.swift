//
//  HomeBanner.swift
//  Home
//
//  Created by 안상희 on 7/5/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture

@Reducer
public struct HomeBanner {
    @ObservableState
    public struct State: Equatable {
        var bannerType: HomeBannerType
        var count: Int?

        public init(bannerType: HomeBannerType, count: Int?) {
            self.bannerType = bannerType
            self.count = count
        }
    }

    public enum Action {
        // MARK: User Action
        case bannerButtonTapped
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { _, action in
            switch action {
            case .bannerButtonTapped:
                // TODO: 버튼 탭 시 동작 구현
                return .none
            }
        }
    }
}
