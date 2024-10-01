//
//  AIClassificationTabView.swift
//  AIClassification
//
//  Created by 김영균 on 7/8/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import SwiftUI

struct AIClassificationTabView: View {
    let store: StoreOf<AIClassificationTab>

    init(store: StoreOf<AIClassificationTab>) {
        self.store = store
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 8) {
                    ForEach(store.folders.indices, id: \.self) { index in
                        LKTopTabView(
                            icon: (store.folders[index].isAIGenerated == true) ? DesignSystemKitAsset.Icons.icStarMedium.swiftUIImage : nil,
                            isSelected: store.selectedFolderIndex == index,
                            title: store.folders[index].name,
                            count: "\(store.folders[index].postCount)"
                        )
                        .id(index)
                        .frame(height: 36)
                        .onTapGesture {
                            store.send(.selectedFolderIndexChanged(selectedFolderIndex: index))
                            withAnimation { proxy.scrollTo(index) }
                        }
                    }
                }
                .padding(EdgeInsets(top: 8, leading: 20, bottom: 12, trailing: 20))
            }
            .frame(height: 56)
        }
    }
}
