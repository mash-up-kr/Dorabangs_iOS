//
//  SaveURL.swift
//  SaveURL
//
//  Created by 김영균 on 6/29/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Models
import Services

@Reducer
public struct SaveURL {
    @ObservableState
    public struct State: Equatable {
        public static let initialState = State(urlString: "")
        /// 텍스트 필드에 입력된 저장할 URL 문자열
        var urlString: String
        /// 저장 버튼 비활성화 여부
        var isSaveButtonDisabled: Bool
        /// 텍스트 필드에 포커스가 있는지 여부
        var isTextFieldFocused: Bool = true
        /// 텍스트 필드에 경고가 표시되었는지 여부
        var isTextFieldWarned: Bool = false
        /// 클립보드 토스트 상태
        var clipboardToast = ClipboardToastFeature.State()

        public init(urlString: String) {
            self.urlString = urlString
            isSaveButtonDisabled = urlString.isEmpty
        }
    }

    public enum Action {
        // MARK: View Action
        case onAppear
        case backButtonTapped
        case saveButtonTapped
        case textFieldChanged(String)
        case isTextFieldWarnedChanged(Bool)

        // MARK: Child Action
        case clipboardToast(ClipboardToastFeature.Action)

        // MARK: Navigation Action
        case routeToPreviousScreen
        case routeToSelectFolderScreen(saveURL: URL)
    }

    public init() {}

    @Dependency(\.urlValidatorClient) var urlValidatorClient

    public var body: some ReducerOf<Self> {
        Scope(state: \.clipboardToast, action: \.clipboardToast) {
            ClipboardToastFeature()
        }
        Reduce { state, action in
            switch action {
            case .onAppear:
                return ClipboardToastFeature()
                    .reduce(into: &state.clipboardToast, action: .presentToast)
                    .map(Action.clipboardToast)

            case .backButtonTapped:
                return .send(.routeToPreviousScreen)

            case .saveButtonTapped:
                return .run { [urlString = state.urlString] send in
                    if let url = URL(string: urlString), let validURL = await urlValidatorClient.validateURL(url) {
                        await send(.routeToSelectFolderScreen(saveURL: validURL))
                    } else {
                        await send(.isTextFieldWarnedChanged(true))
                    }
                }

            case let .textFieldChanged(text):
                return textFieldChanged(&state, text: text)

            case let .isTextFieldWarnedChanged(isWarned):
                state.isTextFieldWarned = isWarned
                state.isSaveButtonDisabled = isWarned
                return .none

            case let .clipboardToast(.pasteURLStringToTextField(urlString)):
                return textFieldChanged(&state, text: urlString)

            default:
                return .none
            }
        }
    }

    func textFieldChanged(_ state: inout State, text: String) -> Effect<Action> {
        state.urlString = text
        state.isTextFieldWarned = false
        state.isSaveButtonDisabled = state.urlString.isEmpty
        return .none
    }
}
