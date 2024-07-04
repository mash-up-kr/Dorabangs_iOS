//
//  HomeBannerView.swift
//  Home
//
//  Created by 안상희 on 7/4/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import SwiftUI

public struct HomeBannerView: View {
    private let store: StoreOf<HomeBanner>

    public init(store: StoreOf<HomeBanner>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            LKBannerView(
                prefix: store.state.bannerType.prefix,
                count: store.state.count) {
                    store.send(.bannerButtonTapped)
                }
        }
    }
}
