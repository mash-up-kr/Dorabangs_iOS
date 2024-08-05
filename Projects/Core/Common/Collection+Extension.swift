//
//  Collection+Extension.swift
//  Common
//
//  Created by 김영균 on 8/5/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import Foundation

public extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
