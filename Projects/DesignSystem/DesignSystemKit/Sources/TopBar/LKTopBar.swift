//
//  LKTopBar.swift
//  DesignSystemKit
//
//  Created by 김영균 on 9/23/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

public struct LKTopBar<LeftContent: View, CenterContent: View, RightContent: View>: View {
    let leftContent: () -> LeftContent
    let centerContent: () -> CenterContent
    let rightContent: () -> RightContent

    public init(
        @ViewBuilder leftContent: @escaping () -> LeftContent
    ) where CenterContent == EmptyView, RightContent == EmptyView {
        self.init(leftContent: leftContent, centerContent: { EmptyView() }, rightContent: { EmptyView() })
    }

    public init(
        @ViewBuilder centerContent: @escaping () -> CenterContent
    ) where LeftContent == EmptyView, RightContent == EmptyView {
        self.init(leftContent: { EmptyView() }, centerContent: centerContent, rightContent: { EmptyView() })
    }

    public init(
        @ViewBuilder rightContent: @escaping () -> RightContent
    ) where LeftContent == EmptyView, CenterContent == EmptyView {
        self.init(leftContent: { EmptyView() }, centerContent: { EmptyView() }, rightContent: rightContent)
    }

    public init(
        @ViewBuilder leftContent: @escaping () -> LeftContent,
        @ViewBuilder centerContent: @escaping () -> CenterContent
    ) where RightContent == EmptyView {
        self.init(leftContent: leftContent, centerContent: centerContent, rightContent: { EmptyView() })
    }

    public init(
        @ViewBuilder leftContent: @escaping () -> LeftContent,
        @ViewBuilder rightContent: @escaping () -> RightContent
    ) where CenterContent == EmptyView {
        self.init(leftContent: leftContent, centerContent: { EmptyView() }, rightContent: rightContent)
    }

    public init(
        @ViewBuilder centerContent: @escaping () -> CenterContent,
        @ViewBuilder rightContent: @escaping () -> RightContent
    ) where LeftContent == EmptyView {
        self.init(leftContent: { EmptyView() }, centerContent: centerContent, rightContent: rightContent)
    }

    public init(
        @ViewBuilder leftContent: @escaping () -> LeftContent,
        @ViewBuilder centerContent: @escaping () -> CenterContent,
        @ViewBuilder rightContent: @escaping () -> RightContent
    ) {
        self.leftContent = leftContent
        self.centerContent = centerContent
        self.rightContent = rightContent
    }

    public var body: some View {
        HStack(spacing: 8) {
            leftContent()
                .frame(height: 24)

            Spacer()

            rightContent()
                .frame(height: 24)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .frame(height: 48)
        .overlay {
            centerContent()
                .frame(height: 24)
        }
    }
}

#Preview {
    LKTopBar(leftContent: { Text("left") })
}
