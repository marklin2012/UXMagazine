//
//  CardEditSelectedCollectionViewFlowLayout.swift
//  UXMagazine
//
//  Created by O2.LinYi on 16/2/22.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

class CardEditSelectedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
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
                
                print(50 * (delta/100))
                
                attribute.center.y = centerY - 10 * (1 - delta/100)
            
        } // for attribute  in attributes!
        
        return attributes
        
    }
    
    
    
}
