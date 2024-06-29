//
//  HorizontalScrollView.swift
//  Home
//
//  Created by 안상희 on 6/21/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

struct HorizontalScrollView: View {
    let itemCount = 5

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(0 ..< itemCount) { _ in
                    Color.red
                        .frame(width: 100, height: 50)
                }
            }
        }
    }
}
