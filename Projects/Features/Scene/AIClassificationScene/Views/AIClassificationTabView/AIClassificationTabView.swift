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
        WithPerceptionTracking {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 8) {
                    ForEach(store.folders, id: \.self) { folder in
                        WithPerceptionTracking {
                            LKTopTabView(
                                folderType: .custom,
                                isSelected: store.selectedFolder == folder,
                                title: folder.name,
                                count: "\(folder.postCount)"
                            )
                            .frame(height: 36)
                            .onTapGesture {
                                store.send(.selectedFolderChanged(selectedFolder: folder))
                            }
                        }
                    }
                }
                .padding(EdgeInsets(top: 8, leading: 20, bottom: 12, trailing: 20))
            }
            .frame(height: 56)
        }
    }
}
