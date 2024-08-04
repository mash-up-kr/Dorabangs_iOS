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
    @Perception.Bindable private var store: StoreOf<Home>

    enum Constant {
        static let LKTopLogoBarHeight: CGFloat = 48
        static let LKTopScrollViewHeight: CGFloat = 56
    }

    public init(store: StoreOf<Home>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            ZStack(alignment: .top) {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        Spacer()
                            .frame(height: Constant.LKTopLogoBarHeight + Constant.LKTopScrollViewHeight)

                        if let selectedFolderId = store.tabs?.selectedFolderId, selectedFolderId == "all" {
                            bannerView
                        }

                        if let store = store.scope(state: \.cards, action: \.cards) {
                            HomeCardView(store: store)
                        }
                    }
                }
                .zIndex(1)
                .background(DesignSystemKitAsset.Colors.white.swiftUIColor.opacity(0.7))
                .background(.ultraThinMaterial)
                .shadow(color: DesignSystemKitAsset.Colors.primary.swiftUIColor.opacity(0.01), blur: 8, x: 0, y: -4)

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
            .applyIf(store.isLoading, apply: { view in
                view.overlay { LoadingIndicator() }
            })
            .onAppear {
                store.send(.onAppear)
            }
        }
    }

    @ViewBuilder
    private var bannerView: some View {
        if let bannerList = store.banner?.bannerList, !bannerList.isEmpty {
            ACarousel(
                bannerList,
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
            .onChange(of: store.bannerIndex) { playBannerLottie(with: bannerList[$0].bannerType) }
            .onAppear { playBannerLottie(with: bannerList[store.bannerIndex].bannerType) }
            .onDisappear { stopBannerLottie() }
            .frame(height: 340)

            if let store = store.scope(state: \.banner, action: \.banner) {
                WithPerceptionTracking {
                    HomeBannerPageControlView(store: store)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
                }
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

private struct HomeBackgroundView: View {
    fileprivate init() {}

    fileprivate var body: some View {
        ZStack {
            DesignSystemKitAsset.Colors.white.swiftUIColor
                .opacity(1)
                .edgesIgnoringSafeArea(.all)

            GeometryReader { _ in
                Circle()
                    .fill(
                        Color(red: 191 / 255, green: 221 / 255, blue: 252 / 255, opacity: 0.5)
                    )
                    .frame(width: 357, height: 357)
                    .blur(radius: 96)
                    .offset(x: -40, y: 28)
            }
        }
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
