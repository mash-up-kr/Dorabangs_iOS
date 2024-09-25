//
//  AISummaryView.swift
//  AISummary
//
//  Created by 김영균 on 9/21/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import LocalizationKit
import SwiftUI

public struct AISummaryView: View {
    private let store: StoreOf<AISummary>

    public init(store: StoreOf<AISummary>) {
        self.store = store
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            LKTextMiddleTopBar(backButtonAction: { store.send(.backButtonTapped) })

            LKDivider()

            titleView
                .padding(.top, 30)
                .padding(.horizontal, 20)

            if let aiSummary = store.aiSummary {
                aiSummaryView(aiSummary)
                    .padding(.top, 10)
                    .padding(.horizontal, 20)
            }

            tagView
                .padding(.top, 20)
                .padding(.horizontal, 20)

            Spacer()

            RoundedButton(title: LocalizationKitStrings.Common.close) {
                store.send(.closeButtonTapped)
            }
            .padding(20)
        }
        .navigationBarHidden(true)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }

    var titleView: some View {
        HStack(spacing: 6) {
            DesignSystemKitAsset.Icons.icStarMedium.swiftUIImage

            Text(LocalizationKitStrings.AISummaryScene.summaryContents)
                .foregroundStyle(DesignSystemKitAsset.Colors.g9.swiftUIColor)
                .font(weight: .bold, semantic: .caption2)
        }
    }

    func aiSummaryView(_ aiSummary: String) -> some View {
        Text(aiSummary)
            .foregroundStyle(DesignSystemKitAsset.Colors.g9.swiftUIColor)
            .font(weight: .regular, semantic: .body)
            .multilineTextAlignment(.leading)
    }

    var tagView: some View {
        HStack(spacing: 6) {
            ForEach(store.tags.prefix(3), id: \.self) { tag in
                LKTag(tag)
            }

            Spacer()
        }
    }
}
