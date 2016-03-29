//
//  O2ContainerTransitionContext.swift
//  UXMagazine
//
//  Created by O2.LinYi on 16/3/22.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

let O2ContainerTransitionEndNotification = "Notification.ContainerTransitionEnd.seedante"

class O2ContainerTransitionContext: NSObject, UIViewControllerContextTransitioning {
    
    // addtive property
    private var animationController: UIViewControllerAnimatedTransitioning?
    // private property for protocol need
    unowned private var privateFromeVC: UIViewController
    unowned private var privateToVC: UIViewController
    unowned private var privateContainerVC: O2ContainerViewController
    unowned private var privateContainerView: UIView
    
    var interactive = false
    var isCancelled = false
    var fromIndex: Int = 0
    var toIndex: Int = 0
    var transitionDuration: CFTimeInterval = 0
    var transitionPercent: CGFloat = 0
    
    init(containerViewController: O2ContainerViewController,
        containerView:UIView,
        fromViewController fromVC: UIViewController,
        toViewController toVC: UIViewController) {
            
            privateContainerVC = containerViewController
            privateContainerView = containerView
            privateFromeVC = fromVC
            privateToVC = toVC
            fromIndex = containerViewController.viewControllers!.indexOf(fromVC)!
            toIndex = containerViewController.viewControllers!.indexOf(toVC)!
            super.init()
            privateToVC.view.frame = privateContainerView.bounds
    }
    
    // 启动非交互式转场
    func startNonInteractiveTransitionWith(delegate: ContainerViewControllerDelegate) {
        // 转场开始前添加toVC,转场动画结束后调用 completeTransition:, 再完成后续操作
        privateContainerVC.addChildViewController(privateToVC)
        // 通过 ContainerViewControllerDelegate 协议生成动画控制器
        animationController = delegate.containerController!(privateContainerVC, animationControllerForTransitionFromViewController: privateFromeVC, toViewController: privateToVC)
        // 启动转场并执行动画
        animationController?.animateTransition(self)
        
    }
    
    func transitionEnd() {
        if animationController != nil && animationController!.respondsToSelector("animationEnded:") == true {
            animationController?.animationEnded!(!isCancelled)
        }
        
        if isCancelled {
            privateContainerVC.restoreSelectedIndex()
            isCancelled = false
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(O2ContainerTransitionEndNotification, object: self)
    }
    
    // MARK: - Protocol Method - Reporting the Transition Progress
    // 协议方法，动画结束后调用
    func completeTransition(didComplete: Bool) {
        if didComplete {
            //转场完成，完成添加 toVC ，并且移除 fromVC 和 fromView
            privateToVC.didMoveToParentViewController(privateContainerVC)
            privateFromeVC.willMoveToParentViewController(privateContainerVC)
            privateFromeVC.view.removeFromSuperview()
            privateFromeVC.removeFromParentViewController()
        } else {
            privateToVC.didMoveToParentViewController(privateContainerVC)
            privateToVC.willMoveToParentViewController(privateContainerVC)
            privateToVC.view.removeFromSuperview()
            privateToVC.removeFromParentViewController()
        }
        
        // 非协议方法，处理收尾工作： 如果动画控制器实现了 animationEnded: 方法则执行，取消则恢复数据
        transitionEnd()
    }
    
    func updateInteractiveTransition(percentComplete: CGFloat) {
        if animationController != nil && interactive == true {
            transitionPercent = percentComplete
            privateContainerView.layer.timeOffset = CFTimeInterval(percentComplete) * transitionDuration
//            privateContainerVC
        }
    }
    
    func finishInteractiveTransition() {
        interactive = false
        let pausedTime = privateContainerView.layer.timeOffset
        privateContainerView.layer.speed = 1.0
        privateContainerView.layer.timeOffset = 0
        privateContainerView.layer.beginTime = 0
        let timeSincePause = privateContainerView.layer.convertTime(CACurrentMediaTime(), fromLayer: nil) - pausedTime
        privateContainerView.layer.beginTime = timeSincePause
        
        let displayLink = CADisplayLink(target: self, selector: "finishChangeButtonAppear:")
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        
    }
    
    func cancelInteractiveTransition() {
        interactive = false
        isCancelled = true
        let displayLink = CADisplayLink(target: self, selector: "reverseCurrentAnimation:")
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
        NSNotificationCenter.defaultCenter().postNotificationName(O2ContainerTransitionEndNotification, object: self)
    }
    
    func transitionWasCancelled() -> Bool {
        return isCancelled
    }
    
    
    
    
    
    // MARK: - Protocol Method - Getting the Transition Behaviors
    func isAnimated() -> Bool {
        if animationController != nil {
            return true
        }
        return false
    }
    
    func isInteractive() -> Bool {
        return interactive
    }
    
    func presentationStyle() -> UIModalPresentationStyle {
        return .Custom
    }
    
    // MARK: - Protocol Method - Accessing the Transition Objects
    func containerView() -> UIView? {
        return privateContainerView
    }
    
    func viewControllerForKey(key: String) -> UIViewController? {
        switch key {
        case UITransitionContextFromViewControllerKey:
            return privateFromeVC
        case UITransitionContextToViewControllerKey:
            return privateToVC
        default: return nil
        }
    }
    
    func viewForKey(key: String) -> UIView? {
        switch key {
        case UITransitionContextFromViewKey:
            return privateFromeVC.view
        case UITransitionContextToViewKey:
            return privateToVC.view
        default: return nil
        }
    }
    
    // MARK: - Protocol Method - Getting the Transition Frame Rectangles
    func initialFrameForViewController(vc: UIViewController) -> CGRect {
        return CGRectZero
    }
    
    func finalFrameForViewController(vc: UIViewController) -> CGRect {
        return vc.view.frame
    }
    
    func targetTransform() -> CGAffineTransform {
        return CGAffineTransformIdentity
    }
    
    

}
