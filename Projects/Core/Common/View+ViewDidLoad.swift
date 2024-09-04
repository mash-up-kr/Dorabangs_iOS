//
//  View+ViewDidLoad.swift
//  Common
//
//  Created by 김영균 on 9/4/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public extension View {
    func onViewDidLoad(perform action: (() -> Void)? = nil) -> some View {
        modifier(ViewDidLoadModifier(action: action))
    }
}

struct ViewDidLoadModifier: ViewModifier {
    @State private var viewDidLoad = false
    let action: (() -> Void)?

    func body(content: Content) -> some View {
        content
            .onAppear {
                if viewDidLoad == false {
                    viewDidLoad = true
                    action?()
                }
            }
    }
}
