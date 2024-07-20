//
//  AIClassificationCardPageModel.swift
//  AIClassification
//
//  Created by 김영균 on 7/20/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation

/// 스크롤 페이지 모델
public struct AIClassificationCardPageModel: Equatable {
    var hasNext: Bool
    var currentPage: Int

    public init(hasNext: Bool, currentPage: Int) {
        self.hasNext = hasNext
        self.currentPage = currentPage
    }
}
