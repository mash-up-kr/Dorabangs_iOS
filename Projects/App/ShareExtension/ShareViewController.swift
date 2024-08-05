//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by 김영균 on 7/1/24.
//

import DesignSystemKit
import Services
import SwiftUI
import UIKit

final class ShareViewController: UIViewController {
    private let stackView = UIStackView()
    private let descriptionLabel = UILabel()
    private let editButton = UIButton()
    private let divider = UIView()
    private let loadingIndicator = UIHostingController(rootView: LoadingIndicator())
    private var url: URL?

    private let folderAPIClient: FolderAPIClient
    private let postAPIClient: PostAPIClient

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        folderAPIClient = .liveValue
        postAPIClient = .liveValue
        try? DesignSystemKitAsset.Typography.registerFont()
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOutsideStackView(_:)))
        view.addGestureRecognizer(tapGesture)

        Task { [weak self] in
            DispatchQueue.main.async { self?.showLoadingIndicator() }
            guard let url = await self?.loadSharedURL() else { return }
            DispatchQueue.main.async { self?.url = url }
            await self?.saveURL(url)
            DispatchQueue.main.async {
                self?.hideLoadingIndicator()
                self?.showSaveMessage()
            }
        }
    }
}

// 출처: https://forums.swift.org/t/how-to-use-non-sendable-type-in-async-reducer-code/62069/6
extension NSItemProvider: @unchecked Sendable {}
private extension ShareViewController {
    @objc
    func didTapOutsideStackView(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: view)
        if !stackView.frame.contains(location) {
            extensionContext?.completeRequest(returningItems: nil)
        }
    }

    func saveURL(_ url: URL) async {
        do {
            let folders = try await folderAPIClient.getFolders()
            // defaultFolder: 나중에 읽을 링크 폴더
            guard let defaultFolder = folders.defaultFolders.first(where: { $0.type == .default }) else { return }
            try await postAPIClient.postPosts(defaultFolder.id, url)
        } catch {}
    }

    func loadSharedURL() async -> URL? {
        let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem
        let itemProvider = extensionItem?.attachments?.first
        guard let itemProvider, itemProvider.hasItemConformingToTypeIdentifier("public.url") else {
            return nil
        }
        return try? await itemProvider.loadItem(forTypeIdentifier: "public.url") as? URL
    }

    @objc
    func editButtonDidTapped() {
        if let url, let appURL = URL(string: "dorabangs://?url=\(url.absoluteString)") {
            open(url: appURL)
            extensionContext?.completeRequest(returningItems: nil)
        } else {
            Task { [weak self] in
                guard
                    let url = await self?.loadSharedURL(),
                    let appURL = URL(string: "dorabangs://?url=\(url.absoluteString)")
                else {
                    return
                }
                self?.open(url: appURL)
                self?.extensionContext?.completeRequest(returningItems: nil)
            }
        }
    }

    // 출처 : https://liman.io/blog/open-url-share-extension-swiftui
    private func open(url: URL) {
        var responder: UIResponder? = self as UIResponder
        let selector = #selector(openURL(_:))

        while let currentResponder = responder {
            if currentResponder != self, currentResponder.responds(to: selector) {
                currentResponder.perform(selector, with: url)
                return
            }
            responder = currentResponder.next
        }
    }

    @objc
    private func openURL(_: URL) {}
}

// MARK: - View Methods

private extension ShareViewController {
    func showSaveMessage() {
        setViewHierarchies()
        setViewConstraints()
        setViewAttributes()
    }

    func showLoadingIndicator() {
        addChild(loadingIndicator)
        loadingIndicator.view.frame = view.frame
        loadingIndicator.view.backgroundColor = .black.withAlphaComponent(0.01)
        view.addSubview(loadingIndicator.view)
        loadingIndicator.didMove(toParent: self)
    }

    func hideLoadingIndicator() {
        loadingIndicator.willMove(toParent: nil)
        loadingIndicator.view.removeFromSuperview()
        loadingIndicator.removeFromParent()
    }

    func setViewHierarchies() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(divider)
        stackView.addArrangedSubview(editButton)
    }

    func setViewConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -87),
            divider.widthAnchor.constraint(equalToConstant: 1),
            divider.heightAnchor.constraint(equalToConstant: 21.5)
        ])
    }

    func setViewAttributes() {
        view.backgroundColor = DesignSystemKitAsset.Colors.white.color.withAlphaComponent(0.01)
        setStackViewAttributes()
        setDescriptionLabelAttributes()
        setEditButtonAttributes()
        setDividerAttributes()
    }

    func setStackViewAttributes() {
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = DesignSystemKitAsset.Colors.g9.color
        stackView.directionalLayoutMargins = .init(top: 16, leading: 12, bottom: 16, trailing: 12)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layer.cornerRadius = 8
        stackView.layer.masksToBounds = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }

    func setDescriptionLabelAttributes() {
        descriptionLabel.text = "나중에 읽을 링크에 저장했어요!"
        descriptionLabel.font = UIFont.nanumSquareNeo(size: 16, weight: 500)
        descriptionLabel.textColor = DesignSystemKitAsset.Colors.white.color
    }

    func setEditButtonAttributes() {
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = DesignSystemKitAsset.Colors.white.color
        var container = AttributeContainer()
        container.font = UIFont.nanumSquareNeo(size: 16, weight: 500)
        configuration.attributedTitle = AttributedString("편집", attributes: container)
        editButton.configuration = configuration
        editButton.addTarget(self, action: #selector(editButtonDidTapped), for: .touchUpInside)
    }

    func setDividerAttributes() {
        divider.backgroundColor = DesignSystemKitAsset.Colors.white.color
    }
}
