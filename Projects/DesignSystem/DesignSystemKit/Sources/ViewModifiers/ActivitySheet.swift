//
//  ActivitySheet.swift
//  DesignSystemKit
//
//  Created by 김영균 on 7/24/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import SwiftUI
import UIKit

public extension View {
    func activitySheet(
        isPresented: Binding<Bool>,
        item: ActivityItem? = nil,
        completion: UIActivityViewController.CompletionWithItemsHandler? = nil
    ) -> some View {
        background(ActivityView(isPresented: isPresented, item: item, completion: completion))
    }
}
