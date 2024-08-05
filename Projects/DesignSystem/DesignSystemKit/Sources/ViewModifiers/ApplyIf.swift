//
//  ApplyIf.swift
//  DesignSystem
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public extension View {
    @ViewBuilder
    func applyIf(_ condition: @autoclosure () -> Bool, apply: (Self) -> some View) -> some View {
        if condition() {
            apply(self)
        } else {
            self
        }
    }
}
