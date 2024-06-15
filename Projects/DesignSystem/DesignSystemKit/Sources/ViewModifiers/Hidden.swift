//
//  Hidden.swift
//  DesignSystem
//
//  Created by 김영균 on 6/13/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public extension View {
    @ViewBuilder
    func hidden(_ isHidden: Bool) -> some View {
        if isHidden {
            hidden()
        } else {
            self
        }
    }
}
