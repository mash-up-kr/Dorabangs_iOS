//
//  DorabangsApp.swift
//  App
//
//  Created by 김영균 on 6/13/24
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import AppCoordinator
import ComposableArchitecture
import DesignSystemKit
import SwiftUI

@main
struct DorabangsApp: App {
    private let store: StoreOf<AppCoordinator> = .init(initialState: .initialState) {
        AppCoordinator()
    }

    init() {
        try? DesignSystemKitAsset.Typography.registerFont()
    }

    var body: some Scene {
        WindowGroup {
            AppCoordinatorView(store: store)
                .onOpenURL { url in
                    let urlcomponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
                    let queryItems = urlcomponents?.queryItems
                    guard let saveURL = queryItems?.first(where: { $0.name == "url" })?.value else { return }
                    store.send(.saveURL(saveURL))
                }
        }
    }
}
