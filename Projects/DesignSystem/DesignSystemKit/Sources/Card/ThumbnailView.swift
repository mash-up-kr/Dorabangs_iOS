//
//  ThumbnailView.swift
//  DesignSystemKit
//
//  Created by 안상희 on 7/26/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct ThumbnailView: View {
    public init() {}

    public var body: some View {
        Image(.imgThumbnail)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 80, height: 80)
    }
}
