//
//  SettingView.swift
//  Setting
//
//  Created by 김영균 on 7/23/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import SwiftUI
import WebKit

public struct SettingView: View {
    @Perception.Bindable private var store: StoreOf<Setting>

    public init(store: StoreOf<Setting>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading) {
                LKTextMiddleTopBar(
                    title: "설정",
                    backButtonAction: { store.send(.routeToPreviousScreen) },
                    rightButtomImage: nil,
                    rightButtonEnabled: nil,
                    action: {}
                )

                Text("디바이스 아이디")
                    .font(weight: .bold, semantic: .caption1)
                    .foregroundStyle(DesignSystemKitAsset.Colors.g9.swiftUIColor)
                    .padding(.horizontal, 16)

                Text(store.deviceID ?? "")
                    .font(weight: .regular, semantic: .caption1)
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .background(DesignSystemKitAsset.Colors.g1.swiftUIColor)
                    .cornerRadius(8, corners: .allCorners)
                    .padding(.horizontal, 16)

                Spacer()

                RoundedCornersButton(title: "초기화", style: .solidBlack, action: { store.send(.reset) })
                    .padding(16)
            }
            .onAppear { store.send(.onAppear) }
            .navigationBarHidden(true)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

public extension View {
    @ViewBuilder
    func applySettingView(action: @escaping () -> Void) -> some View {
        if UserDefaults.standard.bool(forKey: "isSettingOn") == false {
            self
        } else {
            overlay(alignment: .bottomTrailing) {
                Button(
                    action: action,
                    label: {
                        GifImageView("karina-aespa")
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                            .padding(.init(top: 0, leading: 0, bottom: 80, trailing: 20))
                    }
                )
            }
        }
    }
}

struct GifImageView: UIViewRepresentable {
    private let name: String

    init(_ name: String) {
        self.name = name
    }

    func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()
        webview.navigationDelegate = context.coordinator
        let url = Bundle.main.url(forResource: name, withExtension: "gif")!
        let data = try! Data(contentsOf: url)
        webview.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8", baseURL: url.deletingLastPathComponent())
        return webview
    }

    func updateUIView(_ uiView: WKWebView, context _: Context) {
        uiView.reload()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
            webView.evaluateJavaScript("document.documentElement.style.webkitUserSelect='none'", completionHandler: nil)
            webView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none'", completionHandler: nil)
        }
    }
}
