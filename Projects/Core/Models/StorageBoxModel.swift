//
//  StorageBoxModel.swift
//  Models
//
//  Created by 박소현 on 6/29/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation

// TODO: - 서버에서 모델 받으면 수정
public struct StorageBoxModel {
    public let title: String
    public let count: Int
    
    public init(title: String, count: Int) {
        self.title = title
        self.count = count
    }
}
