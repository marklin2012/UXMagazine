//
//  UIViewController+Snapshot.swift
//  UXMagazine
//
//  Created by O2.LinYi on 16/2/17.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

extension UIViewController {
    func imageFormView(aView: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, 0);
        
        view.drawViewHierarchyInRect(view.bounds, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img
    }
}
