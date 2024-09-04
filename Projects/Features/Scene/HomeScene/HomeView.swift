//
//  HomeView.swift
//  Home
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ACarousel
import ComposableArchitecture
import DesignSystemKit
import SwiftUI

public struct HomeView: View {
    @Bindable private var store: StoreOf<Home>

    enum Constant {
        static let LKTopLogoBarHeight: CGFloat = 48
        static let LKTopScrollViewHeight: CGFloat = 56
    }

    public init(store: StoreOf<Home>) {
        self.store = store
    }

    public var body: some View {
        GeometryReader { _ in
            VStack(spacing: 0) {
                topBarView
                    .dividerLine(edge: .bottom)

                ScrollView {
                    LazyVStack(spacing: 0) {
                        if let tabs = store.tabs, tabs.selectedFolderId == "all", let store = store.scope(state: \.banner, action: \.banner) {
                            HomeBannerCarousel(store: store)
                                .padding(.top, 16)
                        }

                        if let store = store.scope(state: \.cards, action: \.cards) {
                            HomeCardView(store: store)
                                .padding(.top, 16)
                        }
                    }
                    .padding(.bottom, 60)
                }
                .applyIf(store.isLoading) { _ in
                    LoadingIndicator()
                }
            }
        }
        .padding(.bottom, 60)
        .navigationBarHidden(true)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if !store.isNavigationPushed {
                store.send(.onAppear)
            } else {
                store.send(.updateNavigationStatus(false))
            }
        }
    }

    @ViewBuilder
    private var topBarView: some View {
        VStack(spacing: 0) {
            LKTopLogoBar {
                store.send(.addLinkButtonTapped)
            }
            .frame(height: Constant.LKTopLogoBarHeight)

            if let store = store.scope(state: \.tabs, action: \.tabs) {
                HomeTabView(store: store)
                    .frame(height: Constant.LKTopScrollViewHeight)
            }
        }
    }
}

struct HomeBannerCarousel: View {
    @Bindable var store: StoreOf<HomeBannerPageControl>

    var body: some View {
        ACarousel(
            store.bannerList,
            id: \.self,
            index: $store.bannerIndex.sending(\.updateBannerPageIndicator),
            spacing: 0,
            headspace: 0,
            sidesScaling: 1,
            isWrap: false,
            autoScroll: .active(TimeInterval(8))
        ) { item in
            HomeBannerView(banner: item) {
                store.send(.bannerButtonTapped(item.bannerType))
            }
            .frame(width: UIScreen.main.bounds.width - 40, height: 334)
            .cornerRadius(20, corners: .allCorners)
        }
        .onChange(of: store.bannerIndex) { _, newValue in
            playBannerLottie(with: store.bannerList[newValue].bannerType)
        }
        .onAppear { playBannerLottie(with: store.bannerList[store.bannerIndex].bannerType) }
        .onDisappear { stopBannerLottie() }
        .frame(height: 334)
        .overlay {
            GeometryReader { geometry in
                HomeBannerPageControlView(store: store)
                    .position(x: geometry.size.width - 60, y: 20)
            }
        }
    }
}
