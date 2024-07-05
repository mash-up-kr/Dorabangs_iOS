//
//  SelectFolder.swift
//  SelectFolder
//
//  Created by 김영균 on 7/3/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import Foundation
import Models
import Services

@Reducer
public struct SelectFolder {
    @ObservableState
    public struct State: Equatable {
        var saveURL: URL
        var saveURLMetadata: URLMetadata?
        var folders: [String] = []
        var selectedFolderIndex: Int?
        var isSaveButtonDisabled: Bool = true

        public init(saveURL: URL) {
            self.saveURL = saveURL
        }
    }

    public enum Action {
        case onAppear
        case backButtonTapped
        case folderSelected(Int)
        case saveButtonTapped
        case createFolderButtonTapped(folders: [String])
        case fetchURLMetadata
        case fetchURLMetadataResult(Result<URLMetadata, Error>)
        case routeToPreviousScreen
    }

    public init() {}

    @Dependency(\.urlMetadataClient) var urlMetadataClient

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.fetchURLMetadata)

            case .backButtonTapped:
                return .send(.routeToPreviousScreen)

            case let .folderSelected(index):
                state.selectedFolderIndex = index
                state.isSaveButtonDisabled = false
                return .none

            case .fetchURLMetadata:
                return .run { [url = state.saveURL] send in
                    await send(.fetchURLMetadataResult(Result { try await urlMetadataClient.fetchMetadata(url) }))
                }

            case let .fetchURLMetadataResult(.success(metadata)):
                state.saveURLMetadata = metadata
                return .none

            case .fetchURLMetadataResult(.failure):
                return .none

            default:
                return .none
            }
        }
    }
}
