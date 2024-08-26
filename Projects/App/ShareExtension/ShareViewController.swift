//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by 김영균 on 7/1/24.
//

import DesignSystemKit
import LocalizationKit
import Services
import SwiftUI
import UIKit

final class ShareViewController: UIViewController {
    private let stackView = UIStackView()
    private let descriptionLabel = UILabel()
    private let actionButton = UIButton()
    private let divider = UIView()
    private let loadingIndicator = UIHostingController(rootView: LoadingIndicator())

    private var url: URL?
    private var postId: String?

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
        configureGesture()
        loadData()
    }

    private func configureGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOutsideStackView(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    private func loadData() {
        Task { [weak self] in
            guard let self else { return }
            do {
                await MainActor.run { self.showLoadingIndicator() }
                let url = try await loadSharedURL()
                await MainActor.run { self.url = url }
                try await saveURL(url)
                await MainActor.run {
                    self.hideLoadingIndicator()
                    self.configureView(with: .success)
                }
            } catch {
                await MainActor.run {
                    self.hideLoadingIndicator()
                    self.configureView(with: .failure)
                }
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

    func saveURL(_ url: URL) async throws {
        let folders = try await folderAPIClient.getFolders()
        guard let defaultFolder = folders.defaultFolders.first(where: { $0.type == .default }) else { return }
        let card = try await postAPIClient.postPosts(defaultFolder.id, url)
        await MainActor.run { self.postId = card.id }
    }

    func loadSharedURL() async throws -> URL {
        guard let extensionItem = extensionContext?.inputItems.first as? NSExtensionItem,
              let url = try await extractURL(from: extensionItem)
        else {
            throw NSError(domain: "ShareViewController", code: 0, userInfo: nil)
        }
        return url
    }

    func extractURL(from item: NSExtensionItem) async throws -> URL? {
        if let urlProvider = item.attachments?.first(where: { $0.hasItemConformingToTypeIdentifier("public.url") }),
           let url = try await urlProvider.loadItem(forTypeIdentifier: "public.url") as? URL
        {
            return url
        }

        if let textProvider = item.attachments?.first(where: { $0.hasItemConformingToTypeIdentifier("public.plain-text") }),
           let text = try await textProvider.loadItem(forTypeIdentifier: "public.plain-text") as? String,
           let url = URL(string: text)
        {
            return url
        }

        return nil
    }

    @objc
    func editButtonDidTapped() {
        guard let url, let postId, let appURL = URL(string: "dorabangs://?url=\(url.absoluteString)&postId=\(postId)") else { return }
        open(url: appURL)
        extensionContext?.completeRequest(returningItems: nil)
    }

    @objc
    func closeButtonDidTapped() {
        extensionContext?.completeRequest(returningItems: nil)
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

private extension ShareViewController {
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

    func configureView(with state: ViewState) {
        configureViewHierarchies()
        configureViewConstraints()
        configureStackView()
        configureDescriptionLabel(for: state)
        configureActionButton(for: state)
        configureDivider()
    }

    func configureViewHierarchies() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.addArrangedSubview(divider)
        stackView.addArrangedSubview(actionButton)
    }

    func configureViewConstraints() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 18),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -87),
            divider.widthAnchor.constraint(equalToConstant: 1),
            divider.heightAnchor.constraint(equalToConstant: 21.5)
        ])
    }

    func configureStackView() {
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

    func configureDescriptionLabel(for state: ViewState) {
        descriptionLabel.text = state == .success ? LocalizationKitStrings.Common.savedToReadLater : LocalizationKitStrings.Common.failedToReadLater
        descriptionLabel.font = UIFont.nanumSquareNeo(size: 16, weight: 500)
        descriptionLabel.textColor = DesignSystemKitAsset.Colors.white.color
    }

    func configureActionButton(for state: ViewState) {
        var configuration = UIButton.Configuration.plain()
        configuration.baseForegroundColor = DesignSystemKitAsset.Colors.white.color
        var container = AttributeContainer()
        container.font = UIFont.nanumSquareNeo(size: 16, weight: 500)
        configuration.attributedTitle = AttributedString(state.actionTitle, attributes: container)
        actionButton.configuration = configuration
        actionButton.removeTarget(nil, action: nil, for: .allEvents)
        actionButton.addTarget(self, action: state.actionSelector, for: .touchUpInside)
    }

    func configureDivider() {
        divider.backgroundColor = DesignSystemKitAsset.Colors.white.color
    }
}

private extension ShareViewController {
    enum ViewState {
        case success, failure

        var actionTitle: String {
            switch self {
            case .success: LocalizationKitStrings.Common.edit
            case .failure: LocalizationKitStrings.Common.close
            }
        }

        var actionSelector: Selector {
            switch self {
            case .success: #selector(ShareViewController.editButtonDidTapped)
            case .failure: #selector(ShareViewController.closeButtonDidTapped)
            }
        }
    }
}
