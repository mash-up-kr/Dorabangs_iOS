//
//  HomeOverlayComponent.swift
//  Home
//
//  Created by 김영균 on 7/10/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
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
        var folders: [String] = ["폴더1", "폴더2", "폴더3", "폴더4", "폴더5"]
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

        // MARK: Navigaiton Action
        case routeToCreateNewFolderScreen
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
                return .send(.routeToCreateNewFolderScreen)

            case let .selectFolderCompleted(folder):
                // TODO: call folder api
                return .run { send in
                    await send(.set(\.isSelectFolderBottomSheetPresented, false))
                    await send(.presentToast(toastMessage: "\(String(describing: folder))(으)로 이동했어요."))
                }
                
            case .deleteButtonTapped:
                return .run { [postId = state.postId] send in
                    try await postAPIClient.deletePost(postId: postId ?? "")
                    await send(.cardDeleted)
                }

            default:
                return .none
            }
        }
    }
}
