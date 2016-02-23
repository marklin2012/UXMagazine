//
//  CardEditSelectedCollectionViewFlowLayout.swift
//  UXMagazine
//
//  Created by O2.LinYi on 16/2/22.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

class CardEditSelectedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private var inset: CGFloat?
    
    override func prepareLayout() {
        super.prepareLayout()
        // 设置内边距
        inset = (collectionView!.frame.size.width - itemSize.width)/2
        sectionInset = UIEdgeInsets(top: 0, left: inset!, bottom: 0, right: inset!)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        //获得已经计算好的布局
        let attributes = super.layoutAttributesForElementsInRect(rect)
        
        //计算中心点的X值
        let centerX = (collectionView?.contentOffset.x)! + (collectionView?.frame.size.width)! / 2
        let centerY = (collectionView?.frame.size.height)! / 2
        
        
        for attribute  in attributes! {
            let delta = fabs(attribute.center.x - centerX)
            
                attribute.center.y = centerY - 10 * (1 - delta/100)
            
        } // for attribute  in attributes!
        
        return attributes
        
    }
    
    override func targetContentOffsetForProposedContentOffset(var proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        // 按页翻动
        let rect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView!.frame.size.width, height: collectionView!.frame.size.height)
        
        let attrs = super.layoutAttributesForElementsInRect(rect)
        
        let centerX = proposedContentOffset.x + (collectionView?.frame.size.width)! / 2
        
        var minDelta = MAXFLOAT
        
        for attr in attrs! {
            if fabs(Double(minDelta)) > fabs(Double(attr.center.x - centerX)) {
                minDelta = Float(attr.center.x - centerX)
            }
        }
        
        proposedContentOffset.x += CGFloat(minDelta)
        return proposedContentOffset
    }
    
    
    
}
