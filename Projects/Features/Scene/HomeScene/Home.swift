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
        public var cards: [String] = ["카드0", "카드1", "카드2", "카드3", "카드4", "카드5", "카드6", "카드7", "카드8", "카드9", "카드10"]
        public static let initialState = State()

        /// 클립보드 토스트 상태
        public var clipboardToast = ClipboardToastFeature.State()
        /// 모달, 토스트 바텀시트 등 화면 덮는 컴포넌트 상태
        var overlayComponent = HomeOverlayComponent.State()

        public init() {}
    }

    public enum Action {
        case onAppear

        // MARK: Inner Business
        case fetchData

        // MARK: User Action
        case addLinkButtonTapped
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
                return .none

            case .fetchData:
                for i in 0 ..< 10 {
                    state.cards.append("카드 0\(i)")
                }
                return .none

            case .addLinkButtonTapped:
                // TODO: 링크 추가 버튼 탭 동작 구현
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
