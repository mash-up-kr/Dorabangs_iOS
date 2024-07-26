//
//  ActivityView.swift
//  DesignSystemKit
//
//  Created by 김영균 on 7/24/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct ActivityView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    private let item: ActivityItem?
    private var completion: UIActivityViewController.CompletionWithItemsHandler?

    public init(
        isPresented: Binding<Bool>,
        item: ActivityItem? = nil,
        completion: UIActivityViewController.CompletionWithItemsHandler? = nil
    ) {
        _isPresented = isPresented
        self.item = item
        self.completion = completion
    }

    public func makeUIViewController(context _: Context) -> UIViewController {
        UIViewController()
    }

    public func updateUIViewController(_ uiViewController: UIViewController, context _: Context) {
        let activityViewController = UIActivityViewController(
            activityItems: item?.activityItems ?? [],
            applicationActivities: item?.applicationActivities
        )
        activityViewController.excludedActivityTypes = item?.excludedTypes
        activityViewController.popoverPresentationController?.sourceView = uiViewController.view
        activityViewController.completionWithItemsHandler = { activityType, completed, returnedItems, error in
            isPresented = false
            completion?(activityType, completed, returnedItems, error)
        }

        if isPresented, uiViewController.presentedViewController == nil {
            uiViewController.present(activityViewController, animated: true)
        }
    }
}
