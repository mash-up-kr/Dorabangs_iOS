//
//  SplashView.swift
//  Splash
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Combine
import ComposableArchitecture
import DesignSystemKit
import Lottie
import SwiftUI

public struct SplashView: View {
    private let store: StoreOf<Splash>
    private let bundle = Bundle(identifier: "com.mashup.dorabangs.designSystemKit")

    public init(store: StoreOf<Splash>) {
        self.store = store
    }

    public var body: some View {
        LottieView(animation: .named(JSONFiles.Splash.jsonName, bundle: bundle ?? .main))
            .playing(loopMode: .repeat(1))
            .animationDidFinish { _ in
                store.send(.isAnimationFinishedChanged(true))
            }
            .frame(width: 126, height: 126)
            .onAppear { store.send(.onAppear) }
            .onReceive(
                Publishers.CombineLatest(store.publisher.isAccessTokenSet, store.publisher.isAnimationFinished)
                    .filter { $0.0 && $0.1 },
                perform: { _ in
                    store.send(.handleRouting)
                }
            )
    }

    func handleRouting() {}
}
