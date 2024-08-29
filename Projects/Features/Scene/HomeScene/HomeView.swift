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
        ZStack(alignment: .top) {
            ScrollView {
                LazyVStack(spacing: 0) {
                    Spacer()
                        .frame(height: Constant.LKTopLogoBarHeight + Constant.LKTopScrollViewHeight)

                    if let tabs = store.tabs, tabs.selectedFolderId == "all", let store = store.scope(state: \.banner, action: \.banner) {
                        HomeBannerCarousel(store: store)
                    }

                    if let store = store.scope(state: \.cards, action: \.cards) {
                        HomeCardView(store: store)
                    }
                }
                .applyIf(store.isLoading) { _ in
                    LoadingIndicator()
                        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height - 60)
                }
                .padding(.bottom, 60)
            }
            .zIndex(1)

            topBarView
                .zIndex(2)
                .background(DesignSystemKitAsset.Colors.white.swiftUIColor.opacity(0.7))
                .background(.ultraThinMaterial)
                .shadow(color: DesignSystemKitAsset.Colors.primary.swiftUIColor.opacity(0.01), blur: 8, x: 0, y: -4)
        }
        .padding(.bottom, 60)
        .homeBackgroundView()
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
        }
        .onChange(of: store.bannerIndex) { _, newValue in
            playBannerLottie(with: store.bannerList[newValue].bannerType)
        }
        .onAppear { playBannerLottie(with: store.bannerList[store.bannerIndex].bannerType) }
        .onDisappear { stopBannerLottie() }
        .frame(height: 340)

        HomeBannerPageControlView(store: store)
            .frame(maxWidth: .infinity)
            .frame(height: 40)
            .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
    }
}

private struct HomeBackgroundView: View {
    fileprivate init() {}

    fileprivate var body: some View {
        GeometryReader { _ in
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 357, height: 357)
                .background(
                    EllipticalGradient(
                        stops: [
                            Gradient.Stop(color: Color(red: 0.75, green: 0.87, blue: 0.99), location: 0.00),
                            Gradient.Stop(color: Color(red: 0.75, green: 0.87, blue: 0.99).opacity(0), location: 1.00)
                        ],
                        center: UnitPoint(x: 0.5, y: 0.5)
                    )
                )
                .cornerRadius(357, corners: .allCorners)
                .offset(x: -40, y: 28)
        }
        .edgesIgnoringSafeArea(.all)
    }
}

private extension View {
    func homeBackgroundView() -> some View {
        ZStack {
            HomeBackgroundView()
            self
        }
    }
}
