//
//  SplashView.swift
//  Splash
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import SwiftUI

public struct SplashView: View {
    private let store: StoreOf<Splash>

    public init(store: StoreOf<Splash>) {
        self.store = store
    }

    public var body: some View {
        Text("Splash View")
            .onAppear { store.send(.onAppear) }
    }
}
