//
//  HomeOverlayComponent.swift
//  Home
//
//  Created by 김영균 on 7/10/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import LocalizationKit
import Services

@Reducer
public struct HomeOverlayComponent {
    @ObservableState
    public struct State: Equatable {
        var postId: String?
        // 카드 액션 시트
        var isCardActionSheetPresented: Bool = false
        // 카드 삭제 확인 모달
        var isDeleteCardModalPresented: Bool = false
        // 폴더 선택 바텀시트
        var folders: [String] = []
        // 폴더와 폴더 id
        var folderList: [String: String] = [:]
        var isSelectFolderBottomSheetPresented: Bool = false
        // 토스트
        var toastMessage: String = ""
        var isToastPresented: Bool = false
    }

    public enum Action: BindableAction {
        // MARK: View Action
        case isSelectFolderBottomSheetPresentedChanged(Bool)
        case presentToast(toastMessage: String)
        case createNewFolderButtonTapped
        case selectFolderCompleted(folder: String?)
        case binding(BindingAction<State>)
        case deleteButtonTapped

        // MARK: Inner Business
        case cardDeleted
        case cardMoved

        // MARK: Navigaiton Action
        case routeToCreateNewFolderScreen(postId: String)
    }

    @Dependency(\.postAPIClient) var postAPIClient

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case let .presentToast(toastMessage):
                state.toastMessage = toastMessage
                state.isToastPresented = true
                return .none

            case let .isSelectFolderBottomSheetPresentedChanged(isPresented):
                state.isSelectFolderBottomSheetPresented = isPresented
                return .none

            case .createNewFolderButtonTapped:
                return .send(.routeToCreateNewFolderScreen(postId: state.postId ?? ""))

            case let .selectFolderCompleted(folder):
                let folderList = UserFolder.shared.list
                let folderId = folderList.first { $0.value == folder }?.key

                return .run { [state] send in
                    try await postAPIClient.movePostFolder(postId: state.postId ?? "", folderId: folderId ?? "")
                    await send(.set(\.isSelectFolderBottomSheetPresented, false))
                    await send(.presentToast(toastMessage: LocalizationKitStrings.HomeScene.moveCardToastMessage(folder ?? "")))
                    await send(.cardMoved)
                }

            case .deleteButtonTapped:
                return .run { [postId = state.postId] send in
                    try await postAPIClient.deletePost(postId: postId ?? "")
                    await send(.cardDeleted)
                }
                
            case .cardDeleted:
                return .run { send in
                    await send(.presentToast(toastMessage: LocalizationKitStrings.HomeScene.deleteCardToastMessage))
                }

            default:
                return .none
            }
        }
    }
}
