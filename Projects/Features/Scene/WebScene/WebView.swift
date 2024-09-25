//
//  WebView.swift
//  Web
//
//  Created by 김영균 on 7/27/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import LocalizationKit
import SwiftUI
import WebKit

public struct WebView: View {
    private let store: StoreOf<Web>

    public init(store: StoreOf<Web>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 0) {
            LKTopBar(leftContent: { topBarLeftButton }, rightContent: { topBarRightButton })

            LKDivider()

            UIWebView(url: store.url)
        }
        .navigationBarHidden(true)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }

    var topBarLeftButton: some View {
        DesignSystemKitAsset.Icons.icChevronLeftBig.swiftUIImage
            .frame(width: 24, height: 24)
            .onTapGesture(perform: { store.send(.backButtonTapped) })
    }

    var topBarRightButton: some View {
        HStack(spacing: 4) {
            DesignSystemKitAsset.Icons.icStarMedium.swiftUIImage

            Text(LocalizationKitStrings.WebScene.showSummary)
                .foregroundStyle(DesignSystemKitAsset.Colors.primary500.swiftUIColor)
                .font(weight: .medium, semantic: .caption2)
        }
        .frame(height: 20)
        .onTapGesture(perform: { store.send(.showSummaryButtonTapped) })
    }
}

private struct UIWebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context _: Context) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context _: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
