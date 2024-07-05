//
//  ClipboardToastFeature.swift
//  SaveURL
//
//  Created by 김영균 on 7/5/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Models

@Reducer
public struct ClipboardToastFeature {
    @ObservableState
    public struct State: Equatable {
        @Shared(.sharedClipboardToast) var shared = SharedClipboardToast()
        var isPresented: Bool = false

        public init() {}
    }

    public enum Action {
        // MARK: Parent Action
        case presentToast

        // MARK: View Action
        case saveButtonTapped
        case closeButtonTapped
        case isPresentedChanged(Bool)

        // MARK: Delegate Action
        case pasteURLStringToTextField(urlString: String)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .presentToast:
                guard state.shared.isCloseButtonTappedAtHome else { return .none }
                state.isPresented = true
                return .none

            case .saveButtonTapped:
                let urlString = state.shared.urlString
                state.shared.clear()
                return .send(.pasteURLStringToTextField(urlString: urlString))

            case .closeButtonTapped:
                state.shared.clear()
                return .none

            case let .isPresentedChanged(isPresented):
                state.isPresented = isPresented
                return .none

            case .pasteURLStringToTextField:
                return .none
            }
        }
    }
}

private extension PersistenceReaderKey where Self == InMemoryKey<SharedClipboardToast> {
    static var sharedClipboardToast: Self { .inMemory("SharedClipboardToast") }
}
