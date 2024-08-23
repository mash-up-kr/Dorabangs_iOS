//
//  DorabangsApp.swift
//  App
//
//  Created by 김영균 on 6/13/24
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import AppCoordinator
import Common
import ComposableArchitecture
import DesignSystemKit
import SwiftUI

@main
struct DorabangsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

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
                    if let urlString = queryItems?.first(where: { $0.name == "url" })?.value, let url = URL(string: urlString) {
                        AnalyticsManager.log(event: ShareExtensionEvent(name: .edit_saved_url))
                        store.send(.saveURL(url))
                    }
                }
        }
    }
}
