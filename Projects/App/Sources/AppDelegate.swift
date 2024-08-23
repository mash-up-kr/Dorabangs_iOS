//
//  AppDelegate.swift
//  App
//
//  Created by 김영균 on 8/23/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import FirebaseCore
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
