//
//  FlowLayoutView.swift
//  Onboarding
//
//  Created by 김영균 on 7/6/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

struct FlowLayoutView<Data: Hashable, Content: View>: UIViewControllerRepresentable {
    var items: [Data]
    let content: (Data) -> Content

    func makeUIViewController(context _: Context) -> FlowLayoutViewController<Data, Content> {
        let viewController = FlowLayoutViewController(items: items, content: content)
        return viewController
    }

    func updateUIViewController(_ uiViewController: FlowLayoutViewController<Data, Content>, context _: Context) {
        uiViewController.update(with: items)
    }
}

final class FlowLayoutViewController<Data: Hashable, Content: View>:
    UIViewController,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
{
    private let cellIdentifier = "Cell"
    private var items: [Data]
    private let content: (Data) -> Content
    private lazy var collectionView: UICollectionView = {
        let flowLayout = FlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.contentInset = .init(top: 1, left: 0, bottom: 1, right: 0)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(HostingCollectionViewCell<Content>.self, forCellWithReuseIdentifier: cellIdentifier)
        return collectionView
    }()

    init(items: [Data], @ViewBuilder content: @escaping (Data) -> Content) {
        self.items = items
        self.content = content
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    func update(with items: [Data]) {
        self.items = items
        collectionView.reloadData()
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellIdentifier,
            for: indexPath
        ) as? HostingCollectionViewCell<Content>
        else {
            return UICollectionViewCell()
        }
        let item = items[indexPath.item]
        cell.host(content(item))
        return cell
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item = items[indexPath.item]
        let hostingController = UIHostingController(rootView: content(item))
        let size = hostingController.sizeThatFits(in: collectionView.bounds.size)
        return size
    }
}

// HostingCollectionViewCell to host SwiftUI content in a UICollectionViewCell
final class HostingCollectionViewCell<Content: View>: UICollectionViewCell {
    private var hostingController: UIHostingController<Content>?

    func host(_ rootView: Content) {
        if hostingController == nil {
            hostingController = UIHostingController(rootView: rootView)
            hostingController!.view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(hostingController!.view)

            NSLayoutConstraint.activate([
                hostingController!.view.topAnchor.constraint(equalTo: contentView.topAnchor),
                hostingController!.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                hostingController!.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                hostingController!.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])

            hostingController!.view.backgroundColor = .clear
        } else {
            hostingController?.rootView = rootView
        }
    }
}
