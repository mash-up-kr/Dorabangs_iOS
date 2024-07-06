//
//  FolderBottomSheetPreview.swift
//  DesignSystemUI
//
//  Created by 박소현 on 6/29/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import DesignSystemKit
import SwiftUI

struct FolderBottomSheetPreview: View {
    @State private var isPresented: Bool = false
    private var folders: [String] = ["새폴더", "개폴더", "말폴더", "새폴더", "개폴더", "말폴더", "새폴더", "개폴더", "말폴더", "새폴더", "개폴더", "말폴더"]

    var body: some View {
        ComponentPreview(component: {
                             FolderBottomSheet(
                                 isPresented: .constant(true),
                                 folders: folders,
                                 onComplete: { _ in
                                     isPresented = false
                                 }
                             )
                             .frame(maxHeight: 600)
                         },
                         options: [])
            .navigationTitle("FolderBottomSheetPreview")
            .toolbar {
                Button("Preview") {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isPresented = true
                    }
                }
            }
            .bottomSheet(
                isPresented: $isPresented,
                folders: folders,
                onComplete: { _ in
                    isPresented = false
                }
            )
    }
}

#Preview {
    FolderBottomSheetPreview()
}
