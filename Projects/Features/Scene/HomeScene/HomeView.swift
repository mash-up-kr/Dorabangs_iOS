//
//  HomeView.swift
//  Home
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct HomeView: View {
    private let store: StoreOf<Home>

    public init(store: StoreOf<Home>) {
        self.store = store
    }

    public var body: some View {
        Text("Home View")
            .onAppear { store.send(.onAppear) }
    }
}
