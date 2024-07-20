//
//  Feed.swift
//  Home
//
//  Created by 박소현 on 6/29/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Models
import Services

@Reducer
public struct Feed {
    @ObservableState
    public struct State: Equatable {
        public var currentFolder: Folder
        public var cards: [String] = ["카드0", "카드1", "카드2", "카드3", "카드4", "카드5", "카드6", "카드7", "카드8", "카드9", "카드10"]

        public var editFolderPopupIsPresented: Bool = false
        public var removeFolderPopupIsPresented: Bool = false
        public var toastPopupIsPresented: Bool = false

        public init(currentFolder: Folder) {
            self.currentFolder = currentFolder
        }
    }

    public enum Action: BindableAction {
        case onAppear
        case backButtonTapped
        case routeToPreviousScreen

        // MARK: Inner Business
        case fetchFolderInfo(String)
        case updateFolderInfo(Result<Folder, Error>)
        case fetchData

        // MARK: User Action
        case tapMore
        case tapAllType
        case tapUnreadType
        case tapSortLatest
        case tapSortPast

        case tapChangeFolderName

        case showRemoveFolderPopup
        case tapRemoveButton
        case removeFolder
        case cancelRemoveFolder

        case routeToChangeFolderName(String)
        case changedFolderName(Folder)

        case bookMarkButtonTapped(Int)
        case showModalButtonTapped(Int)

        case binding(BindingAction<State>)
    }

    public init() {}

    @Dependency(\.folderAPIClient) var folderAPIClient

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.fetchFolderInfo(state.currentFolder.id))
            case let .fetchFolderInfo(folderId):
                return .run { send in
                    await send(.updateFolderInfo(Result { try await folderAPIClient.getFolder(folderId)
                    }))
                }
            case let .updateFolderInfo(.success(folder)):
                state.currentFolder = folder
                return .none
            case .backButtonTapped:
                return .send(.routeToPreviousScreen)
            case .fetchData:
                return .none
            case .tapMore:
                state.editFolderPopupIsPresented = true
                return .none
            case .tapSortLatest:
                return .none
            case .tapSortPast:
                return .none
            case .tapChangeFolderName:
                state.editFolderPopupIsPresented = false
                return .send(.routeToChangeFolderName(state.currentFolder.name))
            case let .routeToChangeFolderName(currentTitle):
                return .none
            case let .changedFolderName(newName):
                // TODO: - 통신탄 결과로 수정해야함~
//                state.title = newName
                state.toastPopupIsPresented = true
                return .none
            case .showRemoveFolderPopup:
                state.removeFolderPopupIsPresented = true
                state.editFolderPopupIsPresented = false
                return .none
            case .tapRemoveButton:
                state.editFolderPopupIsPresented = false
                state.removeFolderPopupIsPresented = false
                return .send(.removeFolder)
            case .cancelRemoveFolder:
                state.editFolderPopupIsPresented = true
                state.removeFolderPopupIsPresented = false
                return .none
            case let .bookMarkButtonTapped(index):
                // TODO: 카드 > 북마크 버튼 탭 동작 구현
                return .none
            case let .showModalButtonTapped(index):
                // TODO: 카드 > 모달 버튼 탭 동작 구현
                return .none
            case .binding:
                return .none
            default:
                return .none
            }
        }
    }
}
