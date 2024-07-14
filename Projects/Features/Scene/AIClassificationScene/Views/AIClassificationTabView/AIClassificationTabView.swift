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
                    ForEach(store.tabs.indices, id: \.self) { index in
                        WithPerceptionTracking {
                            LKTopTabView(
                                folderType: .custom,
                                isSelected: store.selectedIndex == index,
                                title: store.tabs[index].name,
                                count: "\(store.tabs[index].postCount)"
                            )
                            .frame(height: 36)
                            .onTapGesture {
                                store.send(.tabSelected(at: index))
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
