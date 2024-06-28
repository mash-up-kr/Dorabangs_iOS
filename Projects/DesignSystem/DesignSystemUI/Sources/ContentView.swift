//
//  ContentView.swift
//  DesignSystemUI
//
//  Created by 김영균 on 6/18/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("1. Foundation") { foundationPreviews }
                Section("2. Atomic") { atomicPreviews }
                Section("3. Component") { componentPreviews }
            }
            .listStyle(.plain)
            .navigationTitle("DesignSystem")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    @ViewBuilder
    var foundationPreviews: some View {
        NavigationLink("Color") { ColorPreview() }
        NavigationLink("Typography") { TypographyPreview() }
    }
    
    @ViewBuilder
    var atomicPreviews: some View {
        NavigationLink("RoundedButton") { RoundedButtonPreview() }
        NavigationLink("RoundedCornersButton") { RoundedCornersButtonPreview() }
        NavigationLink("TextField") { TextFieldPreview() }
    }
    
    @ViewBuilder
    var componentPreviews: some View {
        NavigationLink("LKCard") { LKCardPreview() }
        NavigationLink("LKClassificationCard") { LKClassificationCardPreview() }
        NavigationLink("Modal") { ModalPreview() }
        NavigationLink("TextField Popup") { TextFieldPopupPreview() }
        NavigationLink("TabBar") { TabBarPreview() }
        NavigationLink("Toast") { ToastPreview() }
        NavigationLink("ClipboardToast") { ClipboardToastPreview() }
    }
}

#Preview {
    ContentView()
}
