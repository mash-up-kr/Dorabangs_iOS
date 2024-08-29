//
//  WebView.swift
//  Web
//
//  Created by 김영균 on 7/27/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import SwiftUI
import WebKit

public struct WebView: View {
    private let store: StoreOf<Web>

    public init(store: StoreOf<Web>) {
        self.store = store
    }

    public var body: some View {
        VStack(spacing: 0) {
            LKTextMiddleTopBar(
                title: "",
                backButtonAction: { store.send(.backButtonTapped) },
                action: {}
            )
            UIWebView(url: store.url)
        }
        .navigationBarHidden(true)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
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
