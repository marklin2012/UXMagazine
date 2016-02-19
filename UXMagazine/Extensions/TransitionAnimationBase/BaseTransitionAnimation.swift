//
//  BaseTransitionAnimation.swift
//  UXMagazine
//
//  Created by O2.LinYi on 16/2/19.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

public enum PresentAnimationType: Int {
    case Presented
    case Dismissed
}

public class BaseTransitionAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    public var transition: PresentAnimationType?
    
    init(type: PresentAnimationType) {
        super.init()
        transition = type
    }
    //子类必须重写以下两个方法
    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 1.0
    }
    
    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
    }
    
}
