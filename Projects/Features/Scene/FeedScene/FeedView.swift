//
//  FeedView.swift
//  Feed
//
//  Created by 박소현 on 6/29/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import ComposableArchitecture
import DesignSystemKit
import SwiftUI

public struct FeedView: View {
    @Perception.Bindable private var store: StoreOf<Feed>

    public init(store: StoreOf<Feed>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            VStack {
                LKTextMiddleTopBar(
                    title: store.currentFolder.name,
                    backButtonAction: { store.send(.backButtonTapped) },
                    rightButtomImage: DesignSystemKitAsset.Icons.icMoreGray.swiftUIImage,
                    rightButtonEnabled: true,
                    action: {
                        store.send(.tapMore, animation: .default)
                    }
                )

                ScrollView {
                    LazyVStack(pinnedViews: .sectionHeaders) {
                        FeedHeaderView(folderName: store.currentFolder.name, linkCount: store.currentFolder.postCount)

                        Section {
                            LazyVStack(spacing: 0) {
                                FeedSortView(onSort: { sortType in
                                    switch sortType {
                                    case .latest:
                                        store.send(.tapSortLatest)
                                    case .past:
                                        store.send(.tapSortPast)
                                    }
                                })

                                ForEach(store.cards.indices, id: \.self) { index in
                                    LKCard(
                                        isSummarizing: true,
                                        progress: 1.0,
                                        title: "에스파 '슈퍼노바', 올해 멜론 주간 차트 최장 1위…'쇠맛' 흥행 질주에스파 '슈퍼노바', 올해 멜론 주간 차트 최장 1위…'쇠맛' 흥행 질주 에스파 '슈퍼노바', 올해 멜론 주간 차트 최장 1위…'쇠맛' 흥행 질주",
                                        description: "사건은 다가와 아 오 에 거세게 커져가 아 오 에 That tick, that tick, tick bomb That tick, that tick, tick bomb 사건은 다가와 아 오 에 거세게 커져가 아 오 에 That tick, that tick, tick bomb That tick, that tick, tick bomb",
                                        tags: ["# 에스파", "# SM", "# 오에이옹에이옹"],
                                        category: "Category",
                                        timeSince: "1일 전",
                                        bookMarkAction: { store.send(.bookMarkButtonTapped(index)) },
                                        showModalAction: { store.send(.showModalButtonTapped(index)) }
                                    )
                                }
                            }
                        } header: {
                            VStack(spacing: 0) {
                                FeedHeaderTabView(select: { selectType in
                                    switch selectType {
                                    case .all:
                                        store.send(.tapAllType)
                                    case .unread:
                                        store.send(.tapUnreadType)
                                    }
                                })
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear { store.send(.onAppear) }
            .editFolderPopup(isPresented: $store.editFolderPopupIsPresented.projectedValue, onSelect: { index in
                if index == 0 {
                    store.send(.showRemoveFolderPopup, animation: .default)
                } else {
                    store.send(.tapChangeFolderName)
                }
            })
            .modal(isPresented: $store.removeFolderPopupIsPresented.projectedValue, content: {
                removeFolderPopup(onCancel: {
                    store.send(.cancelRemoveFolder, animation: .default)
                }, onRemove: {
                    store.send(.tapRemoveButton)
                })
            })
            .toast(isPresented: $store.toastPopupIsPresented, type: .info, message: "폴더 이름을 변경했어요.", isEmbedTabbar: false)
        }
    }
}

extension View {
    func editFolderPopup(isPresented: Binding<Bool>, onSelect: @escaping (Int) -> Void) -> some View {
        modifier(EditFolderPopupModifier(isPresented: isPresented, onSelect: { index in
            onSelect(index)
        }))
    }

    func removeFolderPopup(onCancel: @escaping () -> Void, onRemove: @escaping () -> Void) -> some View {
        LKModal(title: "폴더 삭제", content: "폴더를 삭제하면 모든 데이터가 영구적으로 삭제되어 복구할 수 없어요.\n그래도 삭제하시겠어요?", leftButtonTitle: "취소", leftButtonAction: {
            onCancel()
        }, rightButtonTitle: "삭제", rightButtonAction: {
            onRemove()
        })
    }
}

public struct EditFolderPopupModifier: ViewModifier {
    @Binding var isPresented: Bool
    let onSelect: (Int) -> Void

    public init(isPresented: Binding<Bool>,
                onSelect: @escaping (Int) -> Void)
    {
        _isPresented = isPresented
        self.onSelect = onSelect
    }

    public func body(content: Content) -> some View {
        content
            .actionSheet(isPresented: $isPresented, items: [.init(title: "폴더 삭제", image: DesignSystemKitAsset.Icons.icDelete.swiftUIImage.resizable(), action: {
                onSelect(0)
            }), .init(title: "폴더 이름 변경", image: DesignSystemKitAsset.Icons.icNameEdit.swiftUIImage.resizable(), action: {
                onSelect(1)
            })])
    }
}
