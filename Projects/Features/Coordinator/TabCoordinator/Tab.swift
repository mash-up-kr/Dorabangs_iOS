//
//  Tab.swift
//  TabCoordinator
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

extension TabCoordinator.Tab {
    public var title: String {
        switch self {
        case .home:
            return "Home"
        case .folder:
            return "Folder"
        }
    }
    
    public var icon: Image {
        switch self {
        case .home:
            return Image(systemName: "house")
        case .folder:
            return Image(systemName: "folder")
        }
    }
}
