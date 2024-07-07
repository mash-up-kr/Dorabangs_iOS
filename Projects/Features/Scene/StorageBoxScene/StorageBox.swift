//
//  StorageBox.swift
//  StorageBox
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Models

@Reducer
public struct StorageBox {
    @ObservableState
    public struct State: Equatable {
        public static let initialState = State()

        public var newFolderPopupIsPresented: Bool = false
        public var editFolderPopupIsPresented: Bool = false
        public var removeFolderPopupIsPresented: Bool = false
        public var toastPopupIsPresented: Bool = false

        public var editingIndex: Int?

        public var defaultFolders: [StorageBoxModel] = [
            .init(title: "모든 링크", count: 3),
            .init(title: "즐겨찾기", count: 3),
            .init(title: "나중에 읽을 링크", count: 3)
        ]

        public var customFolders: [StorageBoxModel] = [
            .init(title: "에스파", count: 3),
            .init(title: "아이브", count: 3),
            .init(title: "카리나", count: 300),
            .init(title: "A", count: 3)
        ]

        public init() {}
    }

    public enum Action: BindableAction {
        case onAppear

        case storageBoxTapped(section: Int, index: Int)
        case onEdit(index: Int)
        case routeToFeed(title: String)
        case tapNewFolderButton
        case addNewFolder(String)
        case removeFolder
        case cancelRemoveFolder

        case showRemoveFolderPopup
        case tapChangeFolderName
        case changedFolderName(String)

        case routeToChangeFolderName([String])

        case binding(BindingAction<State>)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case let .storageBoxTapped(section, index):
                let title = (section == 0) ? (state.defaultFolders[index].title) : (state.customFolders[index].title)
                return .send(.routeToFeed(title: title))
            case let .onEdit(index):
                print("onEdit index : \(index)")
                state.editingIndex = index
                state.editFolderPopupIsPresented = true
                return .none
            case .routeToFeed:
                return .none
            case .onAppear:
                return .none
            case .tapNewFolderButton:
                state.newFolderPopupIsPresented = true
                return .none
            case let .addNewFolder(folderName):
                print("add new folder")
                state.customFolders.append(.init(title: folderName, count: 0))
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
                return .send(.routeToChangeFolderName(state.defaultFolders.map(\.title) + state.customFolders.map(\.title)))
            case let .changedFolderName(newName):
                if let editingIndex = state.editingIndex {
                    state.customFolders[editingIndex].title = newName
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
