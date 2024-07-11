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
    @Environment(\.scenePhase) var scenePhase

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
                    VStack(spacing: 0) {
                        Spacer()
                            .frame(height: Constant.LKTopLogoBarHeight + Constant.LKTopScrollViewHeight)

                        ACarousel(
                            store.bannerList,
                            id: \.self,
                            index: $store.bannerIndex.sending(\.updateBannerPageIndicator),
                            spacing: 0,
                            headspace: 0,
                            sidesScaling: 1,
                            isWrap: false,
                            autoScroll: .active(TimeInterval(3))
                        ) { item in
                            HomeBannerView(banner: item) {
                                store.send(.bannerButtonTapped(item.bannerType))
                            }
                        }
                        .frame(height: 340)

                        if store.bannerList.count > 1 {
                            HomeBannerPageControlView(
                                bannerList: store.bannerList,
                                selectedBanner: store.selectedBannerType
                            )
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
                        }

                        LazyVStack(spacing: 0) {
                            Section {
                                LazyVStack(spacing: 0) {
                                    ForEach(store.cardList.indices, id: \.self) { index in
                                        LKCard(
                                            title: "에스파 '슈퍼노바', 올해 멜론 주간 차트 최장 1위…'쇠맛' 흥행 질주에스파 '슈퍼노바', 올해 멜론 주간 차트 최장 1위…'쇠맛' 흥행 질주 에스파 '슈퍼노바', 올해 멜론 주간 차트 최장 1위…'쇠맛' 흥행 질주",
                                            description: "사건은 다가와 아 오 에 거세게 커져가 아 오 에 That tick, that tick, tick bomb That tick, that tick, tick bomb 사건은 다가와 아 오 에 거세게 커져가 아 오 에 That tick, that tick, tick bomb That tick, that tick, tick bomb",
                                            tags: ["# 에스파", "# SM", "# 오에이옹에이옹"],
                                            category: "Category",
                                            timeSince: "1일 전",
                                            bookMarkAction: { store.send(.bookMarkButtonTapped(index)) },
                                            showModalAction: { store.send(.showModalButtonTapped(index), animation: .easeInOut) }
                                        )
                                        .onAppear {
                                            if index % 9 == 0 {
                                                store.send(.fetchData)
                                            }
                                        }
                                    }

                                    if store.cardList.isEmpty {
                                        HomeCardEmptyView()
                                    }
                                }
                            }
                        }
                    }
                }
                .zIndex(1)
                .background(DesignSystemKitAsset.Colors.white.swiftUIColor.opacity(0.7))
                .background(.ultraThinMaterial)
                .shadow(color: DesignSystemKitAsset.Colors.primary.swiftUIColor.opacity(0.01), blur: 8, x: 0, y: -4)

                VStack(spacing: 0) {
                    LKTopLogoBar {
                        store.send(.addLinkButtonTapped)
                    }
                    .frame(height: Constant.LKTopLogoBarHeight)

                    LKTopScrollBar(
                        titleList: ["전체", "즐겨찾기", "나중에 읽을 링크", "나즁에 또 읽을 링크", "영원히 안 볼 링크"],
                        selectedIndex: 0
                    )
                    .frame(height: Constant.LKTopScrollViewHeight)
                }
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
                store.send(.onAppear)
                checkClipboardURL()
            }
            .onChange(of: scenePhase) { newValue in
                guard newValue == .active else { return }
                checkClipboardURL()
            }
        }
    }

    private func checkClipboardURL() {
        if let url = UIPasteboard.general.url {
            store.send(.clipboardURLChanged(url))
            UIPasteboard.general.url = nil
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
