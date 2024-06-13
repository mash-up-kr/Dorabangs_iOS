//
//  FolderView.swift
//  Folder
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct FolderView: View {
    private let store: StoreOf<Folder>
    
    public init(store: StoreOf<Folder>) {
        self.store = store
    }
    
    public var body: some View {
        Text("Folder View")
            .onAppear { store.send(.onAppear) }
    }
}
