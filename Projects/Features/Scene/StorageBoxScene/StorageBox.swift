//
//  StorageBox.swift
//  StorageBox
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Foundation
import LocalizationKit
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

        /// 폴더 편집  팝업 present 여부
        public var editFolderPopupIsPresented: Bool = false
        /// 폴더 삭제 팝업 present 여부
        public var removeFolderPopupIsPresented: Bool = false
        public var toastMessage: String = ""
        /// toast 메시지 present 여부
        public var toastPopupIsPresented: Bool = false
        /// 현재 편집 중인 Folder ID
        public var editingID: String?

        public init() {}
    }

    public enum Action: BindableAction {
        // MARK: View Action
        case onAppear
        case storageBoxTapped(section: Int, folderID: String, folderType: FolderType)
        case onEdit(folderID: String)
        case tapNewFolderButton
        case cancelRemoveFolder
        case showToast(message: String)
        case showRemoveFolderPopup
        case tapRemoveFolderButton
        case tapChangeFolderName

        // MARK: Inner Business
        case fetchFolders
        case fetchFoldersResult(Result<FoldersModel, Error>)
        case removeFolder
        case changedFolderName(Folder)

        // MARK: Navigation Action
        case routeToFeed(Folder)
        case routeToChangeFolderName(String, [String])
        case routeToCreateNewFolderScene
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
            case let .storageBoxTapped(section, folderID, folderType):
                if section == 0 {
                    if folderID.isEmpty {
                        if let folder = state.defaultFolders.first(where: { $0.type == folderType }) {
                            return .send(.routeToFeed(folder))
                        }
                    } else {
                        if let folder = state.defaultFolders.first(where: { $0.id == folderID }) {
                            return .send(.routeToFeed(folder))
                        }
                    }
                } else {
                    if let folder = state.customFolders.first(where: { $0.id == folderID }) {
                        return .send(.routeToFeed(folder))
                    }
                }
                return .none
            case let .onEdit(folderID):
                state.editingID = folderID
                state.editFolderPopupIsPresented = true
                return .none
            case .routeToFeed:
                return .none
            case .tapNewFolderButton:
                return .send(.routeToCreateNewFolderScene)
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
                return .send(.showToast(message: LocalizationKitStrings.StorageBoxScene.deleteCompletedToastMessage))
            case .cancelRemoveFolder:
                state.editFolderPopupIsPresented = true
                state.removeFolderPopupIsPresented = false
                return .none
            case let .showToast(message):
                state.toastMessage = message
                state.toastPopupIsPresented = true
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
                return .send(.showToast(message: LocalizationKitStrings.StorageBoxScene.folderNameChangedToastMessage))
            case .routeToChangeFolderName:
                return .none
            case .routeToCreateNewFolderScene:
                return .none
            case .binding:
                return .none
            }
        }
    }
}
