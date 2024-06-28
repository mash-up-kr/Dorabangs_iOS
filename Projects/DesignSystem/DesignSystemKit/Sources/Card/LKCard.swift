//
//  LKCard.swift
//  DesignSystemKit
//
//  Created by 안상희 on 6/26/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct LKCard: View {
    private let title: String?
    private let description: String?
    private let tags: [String]
    private let category: String?
    private let timeSince: String?
    private let bookMarkAction: () -> Void
    private let showModalAction: () -> Void
    
    public init(
        title: String?,
        description: String?,
        tags: [String],
        category: String?,
        timeSince: String?,
        bookMarkAction: @escaping () -> Void,
        showModalAction: @escaping () -> Void
    ) {
        self.title = title
        self.description = description
        self.tags = tags
        self.category = category
        self.timeSince = timeSince
        self.bookMarkAction = bookMarkAction
        self.showModalAction = showModalAction
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 13) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(title ?? "")
                        .font(weight: .bold, semantic: .caption3)
                        .lineLimit(2)
                    
                    HStack(spacing: 4) {
                        Image(.icStar)
                            .frame(width: 12, height: 16)
                        
                        // TODO: Constants로 변경~
                        Text("주요 내용")
                            .font(weight: .medium, semantic: .s)
                            .foregroundStyle(DesignSystemKitAsset.Colors.g9.swiftUIColor)
                        
                        Spacer()
                    }
                    
                    Text(description ?? "")
                        .font(weight: .regular, semantic: .caption1)
                        .foregroundStyle(DesignSystemKitAsset.Colors.g6.swiftUIColor)
                        .lineLimit(3)
                }
                
                VStack(spacing: 0) {
                    Color.pink
                        .frame(width: 65, height: 65)
                    
                    Spacer()
                }
            }
            
            Spacer()
                .frame(height: 12)
            
            HStack(spacing: 12) {
                ForEach(tags, id: \.self) { tag in
                    LKTag(tag)
                }
                
                Spacer()
            }
            
            Spacer()
                .frame(height: 16)
            
            HStack {
                HStack(spacing: 8) {
                    // TODO: 카테고리, 몇 일 전인지 표시
                    Text("Category")
                        .font(weight: .regular, semantic: .xs)
                        .foregroundStyle(DesignSystemKitAsset.Colors.g5.swiftUIColor)
                    
                    Image(.icEclipse)
                        .frame(width: 2, height: 2)
                    
                    Text("몇 일 전~")
                        .font(weight: .regular, semantic: .xs)
                        .foregroundStyle(DesignSystemKitAsset.Colors.g5.swiftUIColor)
                    
                    Spacer()
                }
                
                Spacer()
                
                HStack(spacing: 12) {
                    Button(action: bookMarkAction) {
                        Image(.icBookmark)
                            .frame(width: 24, height: 24)
                    }
                    
                    Button(action: showModalAction) {
                        Image(.icMore)
                            .frame(width: 24, height: 24)
                    }
                }
            }
        }
        .padding(20)
    }
}
