//
//  StorageBox.swift
//  StorageBox
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Models
import Services

@Reducer
public struct StorageBox {
    @ObservableState
    public struct State: Equatable {
        public static let initialState = State()
        /// 기본 폴더 목록
        public var defaultFolders: [Folder] = []
        /// 유저가 생성한 폴더 목록
        public var customFolders: [Folder] = []

        /// 새 폴더 생성 팝업 present 여부
        public var newFolderPopupIsPresented: Bool = false
        /// 폴더 편집  팝업 present 여부
        public var editFolderPopupIsPresented: Bool = false
        /// 폴더 삭제 팝업 present 여부
        public var removeFolderPopupIsPresented: Bool = false
        /// toast 메시지 present 여부
        public var toastPopupIsPresented: Bool = false
        /// 현재 편집 중인 Folder ID
        public var editingID: String?

        public init() {}
    }

    public enum Action: BindableAction {
        // MARK: View Action
        case onAppear
        case storageBoxTapped(section: Int, folderID: String)
        case onEdit(folderID: String)
        case tapNewFolderButton
        case cancelRemoveFolder
        case showRemoveFolderPopup
        case tapRemoveFolderButton
        case tapChangeFolderName

        // MARK: Inner Business
        case fetchFolders
        case fetchFoldersResult(Result<FoldersModel, Error>)
        case addNewFolder(String)
        case removeFolder
        case changedFolderName(Folder)

        // MARK: Navigation Action
        case routeToFeed(title: String)
        case routeToChangeFolderName(String, [String])

        case binding(BindingAction<State>)
    }

    public init() {}

    @Dependency(\.folderAPIClient) var folderAPIClient

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.fetchFolders)
            case .fetchFolders:
                return .run { send in
                    await send(.fetchFoldersResult(Result { try await
                            folderAPIClient.getFolders()
                    }))
                }
            case let .fetchFoldersResult(.success(foldersModel)):
                state.defaultFolders = foldersModel.defaultFolders
                state.customFolders = foldersModel.customFolders
                return .none
            case .fetchFoldersResult(.failure):
                return .none
            case let .storageBoxTapped(section, folderID):
                // TODO: - 여기 타이틀 안가지고 가도됨, id만 넘기기
                if let title = (section == 0) ? (state.defaultFolders.first(where: { $0.id == folderID })?.name) : (state.customFolders.first(where: { $0.id == folderID })?.name) {
                    return .send(.routeToFeed(title: title))
                }
                return .none
            case let .onEdit(folderID):
                state.editingID = folderID
                state.editFolderPopupIsPresented = true
                return .none
            case .routeToFeed:
                return .none
            case .tapNewFolderButton:
                state.newFolderPopupIsPresented = true
                return .none
            case let .addNewFolder(folderName):
                return .run { send in
                    let folderName = [folderName]
                    try await folderAPIClient.postFolders(folderName)
                    await send(.fetchFolders)
                }
            case .tapRemoveFolderButton:
                if let editingID = state.editingID {
                    return .run { send in
                        try await folderAPIClient.deleteFolder(editingID)
                        await send(.removeFolder)
                    } catch: { _, _ in
                        // TODO: Handle error
                    }
                }
                return .none
            case .removeFolder:
                if let editingID = state.editingID {
                    // 패치 타지 말고 이것만 지우자~
                    state.customFolders.removeAll(where: { $0.id == editingID })
                }
                state.editingID = nil
                state.editFolderPopupIsPresented = false
                state.removeFolderPopupIsPresented = false
                return .none
            case .cancelRemoveFolder:
                state.editFolderPopupIsPresented = true
                state.removeFolderPopupIsPresented = false
                return .none
            case .showRemoveFolderPopup:
                print("show remove folder popup")
                state.removeFolderPopupIsPresented = true
                state.editFolderPopupIsPresented = false
                return .none
            case .tapChangeFolderName:
                if let editingID = state.editingID {
                    return .send(.routeToChangeFolderName(editingID, state.defaultFolders.map(\.name) + state.customFolders.map(\.name)))
                }
                return .none
            case let .changedFolderName(patchedFolder):
                if let patchedFolderIndex = state.customFolders.firstIndex(where: { $0.id == patchedFolder.id }) {
                    state.customFolders[patchedFolderIndex] = patchedFolder
                }
                state.editFolderPopupIsPresented = false
                state.toastPopupIsPresented = true
                return .none
            case .routeToChangeFolderName:
                return .none
            case .binding:
                return .none
            }
        }
    }
}
