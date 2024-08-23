//
//  PostPageModel.swift
//  Feed
//
//  Created by 박소현 on 7/20/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation

public struct PostPageModel: Equatable {
    var currentPage: Int
    var order: Order
    var isRead: Bool?
    var isLast: Bool
    var isLoading: Bool
    var isFavorite: Bool

    enum Order: String {
        case ASC = "asc"
        case DESC = "desc"
    }

    public init() {
        currentPage = 1
        order = .DESC
        isRead = nil
        isLast = false
        isLoading = false
        isFavorite = false
    }

    public func canLoadingMore() -> Bool {
        !isLast && !isLoading
    }
}
