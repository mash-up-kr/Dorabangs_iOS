//
//  URLActivityItemSource.swift
//  SaveURLVideoGuide
//
//  Created by 김영균 on 7/25/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import LinkPresentation
import UIKit

final class URLActivityItemSource: NSObject, UIActivityItemSource {
    var icon: UIImage
    var title: String
    var text: String
    var url: URL

    init(icon: UIImage, title: String, text: String) {
        self.icon = icon
        self.title = title
        self.text = text
        url = URL(dataRepresentation: text.data(using: .utf8)!, relativeTo: nil)!
    }

    func activityViewControllerPlaceholderItem(_: UIActivityViewController) -> Any {
        url
    }

    func activityViewController(_: UIActivityViewController, itemForActivityType _: UIActivity.ActivityType?) -> Any? {
        url
    }

    func activityViewController(_: UIActivityViewController, subjectForActivityType _: UIActivity.ActivityType?) -> String {
        title
    }

    func activityViewControllerLinkMetadata(_: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        metadata.title = title
        metadata.originalURL = url
        metadata.iconProvider = NSItemProvider(object: icon)
        return metadata
    }
}
