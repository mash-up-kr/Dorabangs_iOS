//
//  ComponentPreview.swift
//  DesignSystemUI
//
//  Created by 김영균 on 6/19/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

struct ComponentPreview<Content: View>: View {
    @ViewBuilder var component: () -> Content
    let options: [Option]
    
    var body: some View {
        VStack(spacing: 0) {
            component()
                .frame(
                    maxWidth: .infinity,
                    minHeight: UIScreen.main.bounds.width * 0.6,
                    maxHeight: UIScreen.main.bounds.width * 0.6
                )
                .background(Color(uiColor: .secondarySystemBackground))
            
            Divider()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(options.indices, id: \.self) { index in
                        OptionItem(option: options[index])
                    }
                }
                .padding(8)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}
