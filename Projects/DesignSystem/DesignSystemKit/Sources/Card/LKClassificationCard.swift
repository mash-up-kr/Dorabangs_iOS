//
//  LKClassificationCard.swift
//  DesignSystemKit
//
//  Created by 안상희 on 6/28/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct LKClassificationCard: View {
    private let title: String?
    private let description: String?
    private let tags: [String]
    private let category: String?
    private let timeSince: String?
    private let deleteAction: () -> Void
    private let moveToFolderAction: () -> Void
    
    public init(
        title: String?,
        description: String?,
        tags: [String],
        category: String?,
        timeSince: String?,
        deleteAction: @escaping () -> Void,
        moveToFolderAction: @escaping () -> Void
    ) {
        self.title = title
        self.description = description
        self.tags = tags
        self.category = category
        self.timeSince = timeSince
        self.deleteAction = deleteAction
        self.moveToFolderAction = moveToFolderAction
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                Spacer()
                
                // TODO: 닫기 버튼으로 변경~
                Button(action: deleteAction) {
                    Text("x")
                        .font(weight: .medium, semantic: .caption1)
                        .foregroundStyle(DesignSystemKitAsset.Colors.g4.swiftUIColor)
                }
                .frame(width: 24, height: 24)
            }
            
            Spacer()
                .frame(height: 20)
            
            HStack(spacing: 13) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(title ?? "")
                        .font(weight: .bold, semantic: .caption3)
                        .background(Color.green)
                        .lineLimit(2)
                    
                    HStack(spacing: 4) {
                        // TODO: 반짝 이미지로 변경
                        Color.pink
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
            
            HStack(spacing: 8) {
                // TODO: 카테고리, 몇 일 전인지 표시
                Text("Category")
                    .font(weight: .regular, semantic: .xs)
                    .foregroundStyle(DesignSystemKitAsset.Colors.g5.swiftUIColor)
                
                Color.pink
                    .frame(width: 2, height: 2)
                
                Text("몇 일 전~")
                    .font(weight: .regular, semantic: .xs)
                    .foregroundStyle(DesignSystemKitAsset.Colors.g5.swiftUIColor)
                
                Spacer()
            }
            
            Spacer()
                .frame(height: 20)
            
            Button(action: moveToFolderAction) {
                Text("디자인으로 옮기기~")
                    .font(weight: .medium, semantic: .caption1)
                    .foregroundStyle(DesignSystemKitAsset.Colors.g4.swiftUIColor)
            }
            .frame(height: 36)
        }
        .padding(20)
    }
}
