//
//  CardEditPresentAnimation.swift
//  UXMagazine
//
//  Created by O2.LinYi on 16/2/19.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

public class CardEditPresentAnimation: BaseTransitionAnimation {

    //定义动画时长
    override public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    override public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        if self.transition == .Presented {
            presentAnimation(transitionContext)
        } else {
            dismissAnimation(transitionContext)
        }
        
    }
    
    /**
     present 动画实现
     
     - parameter transitionContext: 转场画布
     */
    private func presentAnimation(transitionContext: UIViewControllerContextTransitioning) {
        
        guard  let toView = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)?.view, let containView = transitionContext.containerView() else {
            return
        }
        containView.addSubview(toView)
        toView.alpha = 0
        
        let fromCtl = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey) as! FirstGuideViewController
        fromCtl.titleLabel.hidden = true
        fromCtl.subTitleLabel.hidden = true
        fromCtl.animationLabel.hidden = false
        fromCtl.animationLabel.transform = CGAffineTransformMakeScale(1.5, 1.5)
        
        UIView.animateWithDuration(transitionDuration(transitionContext), animations: { () -> Void in
            
            
            
            var rect = fromCtl.animationLabel.frame
            rect.origin.y = 32
            fromCtl.animationLabel.frame = rect
            
            fromCtl.animationLabel.transform = CGAffineTransformMakeScale(1, 1)
            
            toView.alpha = 1
            
            }, completion:{ (finished) -> Void in
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }
    
    private func dismissAnimation(transitionContext: UIViewControllerContextTransitioning) {
        
        let toCtl = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) as! FirstGuideViewController
        toCtl.dismissViewControllerAnimated(false, completion: nil)
        //完成之后，实现转场动画结束的方法
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
    }
    
    
}
