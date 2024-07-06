//
//  FlowLayout.swift
//  Onboarding
//
//  Created by 김영균 on 7/6/24.
//  Copyright © 2024 mashup.dorabangs. All rights reserved.
//

import UIKit

final class FlowLayout: UICollectionViewFlowLayout {
    /// 주어진 영역 내의 레이아웃 속성 배열을 반환합니다.
    /// - Parameters:
    ///   - rect: 레이아웃 속성을 검색할 영역
    /// - Returns: 주어진 영역 내의 모든 레이아웃 속성 배열
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutAttributesForElements = super.layoutAttributesForElements(in: rect),
              let collectionView
        else {
            return super.layoutAttributesForElements(in: rect)
        }

        let groupedElements = groupElementsByRow(layoutAttributesForElements)
        let repositionedAttributes = repositionGroups(groupedElements, in: collectionView)

        return repositionedAttributes
    }

    /// 요소들을 행 단위로 그룹화합니다.
    /// - Parameters:
    ///   - layoutAttributesForElements: 주어진 영역 내의 모든 레이아웃 속성 배열
    /// - Returns: 요소들을 그룹화한 결과와 그룹 내 셀 배열
    private func groupElementsByRow(_ layoutAttributesForElements: [UICollectionViewLayoutAttributes]) -> (representedElements: [UICollectionViewLayoutAttributes], groupedCells: [[UICollectionViewLayoutAttributes]]) {
        var representedElements: [UICollectionViewLayoutAttributes] = []
        var groupedCells: [[UICollectionViewLayoutAttributes]] = [[]]
        var previousFrame: CGRect?

        for layoutAttributes in layoutAttributesForElements {
            if layoutAttributes.representedElementKind != nil {
                representedElements.append(layoutAttributes)
                continue
            }

            guard let currentItemAttributes = layoutAttributes.copy() as? UICollectionViewLayoutAttributes else { continue }

            if let previousFrame,
               !currentItemAttributes.frame.intersects(
                   CGRect(
                       x: -.greatestFiniteMagnitude,
                       y: previousFrame.origin.y,
                       width: .infinity,
                       height: previousFrame.size.height
                   ))
            {
                groupedCells.append([])
            }
            groupedCells[groupedCells.endIndex - 1].append(currentItemAttributes)
            previousFrame = currentItemAttributes.frame
        }

        return (representedElements, groupedCells)
    }

    /// 그룹화된 요소들을 재배치합니다.
    /// - Parameters:
    ///   - groupedElements: 그룹화된 요소들 (representedElements와 groupedCells)
    ///   - collectionView: 요소들이 속한 UICollectionView
    /// - Returns: 재배치된 레이아웃 속성 배열
    private func repositionGroups(
        _ groupedElements: (representedElements: [UICollectionViewLayoutAttributes], groupedCells: [[UICollectionViewLayoutAttributes]]),
        in collectionView: UICollectionView
    ) -> [UICollectionViewLayoutAttributes] {
        var repositionedAttributes: [UICollectionViewLayoutAttributes] = groupedElements.representedElements

        for group in groupedElements.groupedCells {
            guard let section = group.first?.indexPath.section else {
                repositionedAttributes.append(contentsOf: group)
                continue
            }

            repositionedAttributes.append(contentsOf: repositionGroup(group, inSection: section, collectionView: collectionView))
        }

        return repositionedAttributes
    }

    /// 특정 섹션의 그룹 내 요소들을 재배치합니다.
    /// - Parameters:
    ///   - group: 그룹 내의 요소 배열
    ///   - section: 요소들이 속한 섹션
    ///   - collectionView: 요소들이 속한 UICollectionView
    /// - Returns: 재배치된 레이아웃 속성 배열
    private func repositionGroup(
        _ group: [UICollectionViewLayoutAttributes],
        inSection section: Int,
        collectionView: UICollectionView
    ) -> [UICollectionViewLayoutAttributes] {
        let evaluatedSectionInset = evaluatedSectionInsetForSection(at: section)
        let evaluatedMinimumInteritemSpacing = evaluatedMinimumInteritemSpacingForSection(at: section)

        // collectionView의 전체 너비에서 섹션 여백을 제외한 너비를 구합니다.
        // 예제: collectionView의 너비가 320, 섹션 여백이 좌우 각각 10이라면, totalWidth는 300입니다.
        let totalWidth = collectionView.bounds.width - evaluatedSectionInset.left - evaluatedSectionInset.right

        // 그룹 내 모든 요소의 너비를 합산합니다.
        // 예제: 요소들이 각각 50, 60, 70의 너비를 가진다면, groupWidth는 180입니다.
        let groupWidth = group.reduce(0) { $0 + $1.frame.size.width }

        // 그룹 내 요소 간의 총 간격을 계산합니다.
        // 예제: 요소 간 간격이 10이고, 요소가 3개라면, 총 간격은 20입니다 (간격은 요소 수 - 1).
        let totalSpacing = CGFloat(group.count - 1) * evaluatedMinimumInteritemSpacing

        // 그룹이 중앙에 오도록 초기 오프셋을 계산합니다.
        // 예제: totalWidth가 300, groupWidth가 180, totalSpacing이 20이라면, initialOffset는 50입니다.
        let initialOffset = (totalWidth - groupWidth - totalSpacing) / 2

        var origin = initialOffset + evaluatedSectionInset.left
        return group.map {
            let attributes = $0
            attributes.frame.origin.x = origin
            origin += attributes.frame.size.width + evaluatedMinimumInteritemSpacing
            return attributes
        }
    }
}

extension UICollectionViewFlowLayout {
    /// 주어진 섹션에 대한 평가된 섹션 여백을 반환합니다.
    /// - Parameters:
    ///   - section: 평가할 섹션
    /// - Returns: 해당 섹션에 대한 UIEdgeInsets 값
    func evaluatedSectionInsetForSection(at section: Int) -> UIEdgeInsets {
        guard let collectionView else { return sectionInset }
        return (collectionView.delegate as? UICollectionViewDelegateFlowLayout)?
            .collectionView?(collectionView, layout: self, insetForSectionAt: section) ?? sectionInset
    }

    /// 주어진 섹션에 대한 평가된 최소 아이템 간 간격을 반환합니다.
    /// - Parameters:
    ///   - section: 평가할 섹션
    /// - Returns: 해당 섹션에 대한 최소 아이템 간 간격 (CGFloat)
    func evaluatedMinimumInteritemSpacingForSection(at section: Int) -> CGFloat {
        guard let collectionView else { return minimumInteritemSpacing }
        return (collectionView.delegate as? UICollectionViewDelegateFlowLayout)?
            .collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: section) ?? minimumInteritemSpacing
    }
}
