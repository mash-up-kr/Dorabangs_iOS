//
//  StorageBoxView.swift
//  StorageBox
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct StorageBoxView: View {
    private let store: StoreOf<StorageBox>

    public init(store: StoreOf<StorageBox>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            Text("StorageBox View")
                .onAppear { store.send(.onAppear) }
        }
    }
}
