//
//  HomeCardEmptyView.swift
//  Home
//
//  Created by 안상희 on 7/10/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import LocalizationKit
import SwiftUI

struct HomeCardEmptyView: View {
    var body: some View {
        VStack(spacing: 12) {
            DesignSystemKitAsset.Icons.icEmpty.swiftUIImage
                .frame(width: 40, height: 40)
            
            Text(LocalizationKitStrings.HomeScene.homeCardEmptyViewDescription)
                .font(weight: .medium, semantic: .caption3)
                .foregroundStyle(DesignSystemKitAsset.Colors.g3.swiftUIColor)
                .frame(maxWidth: .infinity)
        }
        .frame(height: getScreenHeightExcludingSafeArea())
        .frame(alignment: .center)
        .background(DesignSystemKitAsset.Colors.white.swiftUIColor)
    }
    
    
    private func getScreenHeightExcludingSafeArea() -> CGFloat {
        // 전체 화면 높이 구하기
        let screenHeight = UIScreen.main.bounds.height

        // UIWindowScene을 통해 Safe Area Insets 구하기
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }

        let safeAreaInsets = keyWindow?.safeAreaInsets ?? UIEdgeInsets.zero
        let safeAreaHeight = safeAreaInsets.top + safeAreaInsets.bottom

        // Safe Area를 제외한 높이 계산 - (상단 바 + 상단 스크롤바 + 하단 탭바)
        return screenHeight - safeAreaHeight - (48 + 56 + 60)
    }
}
