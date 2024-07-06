//
//  ClipboardToastFeature.swift
//  Home
//
//  Created by 김영균 on 7/4/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Models

@Reducer
public struct ClipboardToastFeature {
    @ObservableState
    public struct State: Equatable {
        @Shared(.clipboardToast) var shared = SharedClipboardToast()
        var isPresented: Bool = false

        public init() {}
    }

    public enum Action {
        // MARK: Parent Action
        case presentToast(URL)

        // MARK: View Action
        case saveButtonTapped
        case closeButtonTapped
        case isPresentedChanged(Bool)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .presentToast(url):
                state.shared = SharedClipboardToast(urlString: url.absoluteString)
                state.isPresented = true
                return .none

            case .saveButtonTapped:
                return .none

            case .closeButtonTapped:
                state.shared.closeButtonTappedAtHome()
                return .none

            case let .isPresentedChanged(isPresented):
                state.isPresented = isPresented
                return .none
            }
        }
    }
}

private extension PersistenceReaderKey where Self == InMemoryKey<SharedClipboardToast> {
    static var clipboardToast: Self { .inMemory("SharedClipboardToast") }
}
