//
//  TabCoordinatorView.swift
//  TabCoordinator
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import FolderCoordinator
import HomeCoordinator
import SwiftUI

public struct TabCoordinatorView: View {
    @Bindable private var store: StoreOf<TabCoordinator>
    
    public init(store: StoreOf<TabCoordinator>) {
        self.store = store
    }
    
    public var body: some View {
        TabView(selection: $store.selectedTab.sending(\.tabSelected)) {
            HomeCoordinatorView(store: store.scope(state: \.home, action: \.home))
                .tabItem(TabCoordinator.Tab.home)
                .tag(TabCoordinator.Tab.home)
            
            FolderCoordinatorView(store: store.scope(state: \.folder, action: \.folder))
                .tabItem(TabCoordinator.Tab.folder)
                .tag(TabCoordinator.Tab.folder)
        }
    }
}


extension View {
    func tabItem(_ tabItem: TabCoordinator.Tab) -> some View {
        self.modifier(TabItemModifier(tabItem: tabItem))
    }
}

struct TabItemModifier: ViewModifier {
    let tabItem: TabCoordinator.Tab
    
    func body(content: Content) -> some View {
        content
            .tabItem {
                VStack {
                    tabItem.icon
                    Text(tabItem.title)
                }
            }
    }
}
