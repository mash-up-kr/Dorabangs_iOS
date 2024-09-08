//
//  HomeTabView.swift
//  Home
//
//  Created by 안상희 on 7/14/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Common
import ComposableArchitecture
import DesignSystemKit
import SwiftUI

struct HomeTabView: View {
    let store: StoreOf<HomeTab>

    init(store: StoreOf<HomeTab>) {
        self.store = store
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 8) {
                    ForEach(store.tabs.indices, id: \.self) { index in
                        WithPerceptionTracking {
                            if let tab = store.tabs[safe: index] {
                                LKTopTabView(
                                    isSelected: store.selectedIndex == index,
                                    title: tab.name
                                )
                                .id(index)
                                .frame(height: 36)
                                .onTapGesture {
                                    store.send(.tabSelected(at: index))
                                    withAnimation { proxy.scrollTo(index) }
                                }
                            }
                        }
                    }
                }
                .padding(EdgeInsets(top: 4, leading: 20, bottom: 12, trailing: 20))
            }
            .frame(height: 52)
            .tabShadow()
        }
    }
}
