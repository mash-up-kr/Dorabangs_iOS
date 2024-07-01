//
//  FolderView.swift
//  DesignSystemKit
//
//  Created by 박소현 on 7/1/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct FolderView: View {
    
    private let title: String
    var isSelected: Bool
    
    public init(title: String, isSelected: Bool) {
        self.title = title
        self.isSelected = isSelected
    }
    
    public var body: some View {
        HStack {
            Image(.icFloderFilled)
                .resizable()
                .frame(width: 24, height: 24)
            
            Text(title)
                .font(weight: .regular, semantic: .caption3)
            
            Spacer()
            
            Image(.icSelect)
                .resizable()
                .frame(width: 24, height: 24)
                .hidden(!isSelected)
        }
    }
}
