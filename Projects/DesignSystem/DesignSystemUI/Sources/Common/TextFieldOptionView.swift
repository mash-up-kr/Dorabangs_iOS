//
//  TextFieldOptionView.swift
//  DesignSystemUI
//
//  Created by 김영균 on 6/19/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import SwiftUI

struct TextFieldOptionView: View {
    let description: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(description)
                .font(.system(size: 15, weight: .bold))
            
            Text("String")
                .font(.system(size: 13, weight: .regular))
            
            TextField("", text: $text)
                .font(.system(size: 15, weight: .regular))
                .padding(16)
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(8, corners: .allCorners)
        }
    }
}
