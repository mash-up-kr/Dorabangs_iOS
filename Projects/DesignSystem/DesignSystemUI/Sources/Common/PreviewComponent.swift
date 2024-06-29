//
//  PreviewComponent.swift
//  DesignSystemKit
//
//  Created by 김영균 on 6/18/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

struct PreviewList<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        List(content: content)
            .listStyle(.plain)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct PreviewSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        Section(title, content: content)
            .listSectionSeparator(.hidden)
    }
}
