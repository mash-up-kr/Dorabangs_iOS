//
//  DesignSystemUIApp.swift
//  App
//
//  Created by 김영균 on 6/18/24
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import SwiftUI

@main
struct DorabangsApp: App {
    init() {
        try? DesignSystemKitAsset.Typography.registerFont()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
