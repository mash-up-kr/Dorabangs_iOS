//
//  VideoPlayerView.swift
//  AIClassification
//
//  Created by 김영균 on 7/24/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import AVFoundation
import AVKit
import DesignSystemKit
import Foundation
import SwiftUI

struct VideoLoopPlayerView: View {
    private var player = AVPlayer()

    init(videoURL: URL) {
        player = AVPlayer(url: videoURL)
    }

    var body: some View {
        VideoPlayerView(player: player)
            .onReceive(NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)) { _ in
                player.seek(to: .zero)
                player.play()
            }
    }
}

struct VideoPlayerView: UIViewControllerRepresentable {
    let player: AVPlayer

    func makeUIViewController(context _: Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        playerViewController.showsPlaybackControls = false
        playerViewController.view.backgroundColor = .clear
        player.play()
        return playerViewController
    }

    func updateUIViewController(_: AVPlayerViewController, context _: Context) {}
}
