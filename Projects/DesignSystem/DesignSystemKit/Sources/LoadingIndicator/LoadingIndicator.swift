//
//  LoadingIndicator.swift
//  DesignSystemKit
//
//  Created by 김영균 on 7/24/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Lottie
import SwiftUI

public struct LoadingIndicator: View {
    public init() {}

    public var body: some View {
        LottieView(
            animation: .named(
                JSONFiles.Spinner.jsonName,
                bundle: .init(identifier: "com.mashup.dorabangs.designSystemKit") ?? .module
            )
        )
        .playing(loopMode: .loop)
    }
}
