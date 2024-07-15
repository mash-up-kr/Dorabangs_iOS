//
//  HomeTabView.swift
//  Home
//
//  Created by 안상희 on 7/14/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import SwiftUI

struct HomeTabView: View {
    let store: StoreOf<HomeTab>

    init(store: StoreOf<HomeTab>) {
        self.store = store
    }

    var body: some View {
        WithPerceptionTracking {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 8) {
                    ForEach(store.tabs.indices, id: \.self) { index in
                        WithPerceptionTracking {
                            LKTopTabView(
                                folderType: TopFolderType(string: store.tabs[index].type.toString) ?? .custom,
                                isSelected: store.selectedIndex == index,
                                title: store.tabs[index].name
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
