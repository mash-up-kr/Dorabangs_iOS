//
//  LKTabBarItem.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/24/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct LKTabBarItem<SelectionValue: Hashable>: Identifiable {
    public let id = UUID()
    public let tag: SelectionValue
    public let title: String
    public let image: Image
    public let selectedImage: Image

    public init(tag: SelectionValue, title: String, image: Image, selectedImage: Image) {
        self.tag = tag
        self.title = title
        self.image = image
        self.selectedImage = selectedImage
    }
}
