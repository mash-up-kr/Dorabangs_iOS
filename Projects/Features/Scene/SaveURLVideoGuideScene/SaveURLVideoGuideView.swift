//
//  SaveURLVideoGuideView.swift
//  SaveURLVideoGuide
//
//  Created by 김영균 on 7/24/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import AVKit
import ComposableArchitecture
import DesignSystemKit
import LocalizationKit
import SwiftUI

public struct SaveURLVideoGuideView: View {
    @Perception.Bindable private var store: StoreOf<SaveURLVideoGuide>
    private let videoFilePath: String?

    public init(store: StoreOf<SaveURLVideoGuide>) {
        self.store = store
        let bundle = Bundle(identifier: "com.mashup.dorabangs.designSystemKit")
        videoFilePath = bundle?.path(forResource: "ActivityViewSettingVideo", ofType: "mp4")
    }

    public var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: 0) {
                LKTextMiddleTopBar(
                    title: "",
                    backButtonAction: { store.send(.backButtonTapped) },
                    rightButtomImage: nil,
                    rightButtonEnabled: nil,
                    action: {}
                )

                VStack(alignment: .leading, spacing: 4) {
                    Text(LocalizationKitStrings.SaveURLVideoGuideScene.easyLinkSaving)
                        .font(weight: .bold, semantic: .subtitle1)
                        .foregroundStyle(DesignSystemKitAsset.Colors.g9.swiftUIColor)

                    Text(LocalizationKitStrings.SaveURLVideoGuideScene.wayToSave)
                        .font(weight: .bold, semantic: .subtitle1)
                        .foregroundStyle(DesignSystemKitAsset.Colors.g9.swiftUIColor)
                }
                .padding(EdgeInsets(top: 12, leading: 20, bottom: 0, trailing: 20))

                VStack(alignment: .leading, spacing: 8) {
                    StepDescriptionView(step: 1, description: LocalizationKitStrings.SaveURLVideoGuideScene.step1Description)
                    StepDescriptionView(step: 2, description: LocalizationKitStrings.SaveURLVideoGuideScene.step2Description)
                    StepDescriptionView(step: 3, description: LocalizationKitStrings.SaveURLVideoGuideScene.step3Description)
                }
                .padding(EdgeInsets(top: 18, leading: 20, bottom: 20, trailing: 20))

                if let videoFilePath {
                    VideoLoopPlayerView(videoURL: URL(fileURLWithPath: videoFilePath))
                }

                Spacer()

                RoundedButton(title: LocalizationKitStrings.SaveURLVideoGuideScene.settingButton, action: { store.send(.settingButtonTapped) })
                    .padding(20)
            }
            .activitySheet(
                isPresented: $store.isPresented.sending(\.isPresentedChanged),
                item: ActivityItem(
                    activityItems: [
                        URLActivityItemSource(
                            icon: DesignSystemKitAsset.Icons.icAppIcon.image,
                            title: "Linkit",
                            text: "https://www.linkit.com"
                        )
                    ],
                    excludedTypes: UIActivity.ActivityType.all
                )
            )
            .navigationBarHidden(true)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

private extension UIActivity.ActivityType {
    static let all: [UIActivity.ActivityType] = [
        .postToFacebook,
        .postToTwitter,
        .message,
        .mail,
        .copyToPasteboard,
        .assignToContact,
        .saveToCameraRoll,
        .print,
        .addToReadingList,
        .postToFlickr,
        .postToVimeo,
        .postToWeibo,
        .postToTencentWeibo,
        .airDrop,
        .openInIBooks,
        .markupAsPDF
    ]
}
