//
//  DorabangsApp.swift
//  App
//
//  Created by 김영균 on 6/13/24
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import AppCoordinator
import ComposableArchitecture
import SwiftUI
import DesignSystemKit

@main
struct DorabangsApp: App {
    init() {
        try? DesignSystemKitAsset.Typography.registerFont()
    }
    
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(
                store: Store(initialState: .initialState) {
                    AppCoordinator()
                }
            )
        }
    }
}
