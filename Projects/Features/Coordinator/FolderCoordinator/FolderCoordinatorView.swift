//
//  FolderCoordinatorView.swift
//  FolderCoordinator
//
//  Created by 김영균 on 6/14/24.
//

import ComposableArchitecture
import Folder
import SwiftUI
import TCACoordinators

public struct FolderCoordinatorView: View {
    private let store: StoreOf<FolderCoordinator>
    
    public init(store: StoreOf<FolderCoordinator>) {
        self.store = store
    }
    
    public var body: some View {
        TCARouter(store.scope(state: \.routes, action: \.router)) { screen in
            switch screen.case {
            case let .folder(store):
                FolderView(store: store)
            }
        }
    }
}
