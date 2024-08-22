//
//  OffsetObservableScrollView.swift
//  Common
//
//  Created by 김영균 on 8/23/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI

// 출처 : https://green1229.tistory.com/463
public struct OffsetObservableScrollView<Content: View>: View {
    private var axes: Axis.Set = .vertical
    private var showsIndicators: Bool = true
    @Binding private var scrollOffset: CGPoint
    @ViewBuilder private var content: (ScrollViewProxy) -> Content
    @Namespace private var coordinateSpaceName: Namespace.ID

    public init(
        _ axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        scrollOffset: Binding<CGPoint>,
        @ViewBuilder content: @escaping (ScrollViewProxy) -> Content
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        _scrollOffset = scrollOffset
        self.content = content
    }

    public var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            ScrollViewReader { scrollViewProxy in
                content(scrollViewProxy)
                    .background {
                        GeometryReader { geometryProxy in
                            Color.clear
                                .preference(
                                    key: ScrollOffsetPreferenceKey.self,
                                    value: CGPoint(
                                        x: -geometryProxy.frame(in: .named(coordinateSpaceName)).minX,
                                        y: -geometryProxy.frame(in: .named(coordinateSpaceName)).minY
                                    )
                                )
                        }
                    }
            }
        }
        .coordinateSpace(name: coordinateSpaceName)
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            scrollOffset = value
        }
    }

    private struct ScrollOffsetPreferenceKey: SwiftUI.PreferenceKey {
        static var defaultValue: CGPoint { .zero }

        static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
            value.x += nextValue().x
            value.y += nextValue().y
        }
    }
}
