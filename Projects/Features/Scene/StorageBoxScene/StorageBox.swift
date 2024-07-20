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
        /// 현재 편집 중인 Folder Index
        public var editingIndex: Int?

        public init() {}
    }

    public enum Action: BindableAction {
        // MARK: View Action
        case onAppear
        case storageBoxTapped(section: Int, index: Int)
        case onEdit(index: Int)
        case tapNewFolderButton
        case cancelRemoveFolder
        case showRemoveFolderPopup
        case tapChangeFolderName

        // MARK: Inner Business
        case fetchFolders
        case fetchFoldersResult(Result<FoldersModel, Error>)
        case addNewFolder(String)
        case removeFolder
        case changedFolderName(String)

        // MARK: Navigation Action
        case routeToFeed(title: String)
        case routeToChangeFolderName([String])

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
            case let .storageBoxTapped(section, index):
                let title = (section == 0) ? (state.defaultFolders[index].name) : (state.customFolders[index].name)
                return .send(.routeToFeed(title: title))
            case let .onEdit(index):
                print("onEdit index : \(index)")
                state.editingIndex = index
                state.editFolderPopupIsPresented = true
                return .none
            case .routeToFeed:
                return .none
            case .tapNewFolderButton:
                state.newFolderPopupIsPresented = true
                return .none
            case let .addNewFolder(folderName):
                print("add new folder")
                // TODO: - 여기 통신으로 새폴더 만들어야함
//                state.customFolders.append(.init(title: folderName, count: 0))
                return .none
            case .removeFolder:
                if let editingIndex = state.editingIndex {
                    state.customFolders.remove(at: editingIndex)
                }
                state.editingIndex = nil
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
                return .send(.routeToChangeFolderName(state.defaultFolders.map(\.name) + state.customFolders.map(\.name)))
            case let .changedFolderName(newName):
                // TODO: - 여기도 통신타서 바꾸는걸로

                if let editingIndex = state.editingIndex {
                    state.customFolders[editingIndex].name = newName
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
