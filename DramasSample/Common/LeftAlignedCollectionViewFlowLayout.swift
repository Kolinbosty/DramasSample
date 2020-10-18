//
//  LeftAlignedCollectionViewFlowLayout.swift
//  DramasSample
//
//  Created by  Alex Lin on 2020/10/18.
//

import UIKit

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    // Note: 當然還有塞空白 Cell 的方式，這邊用改 layout 的方式。
    // Copied from stack overflow
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        let sectionCount = collectionView?.numberOfSections ?? 0
        var sectionInsets: [UIEdgeInsets] = Array(repeating: sectionInset, count: sectionCount)
        if let delegate = collectionView?.delegate as? UICollectionViewDelegateFlowLayout,
           let collectionView = collectionView {
            sectionInsets = (0..<sectionCount).map { [self] section in
                let insets = delegate.collectionView?(collectionView, layout: self, insetForSectionAt: section)
                return insets ?? sectionInset
            }
        }

        var leftMargin = sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInsets[layoutAttribute.indexPath.section].left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}
