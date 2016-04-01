//
//  O2ContainerTransitionContext.swift
//  UXMagazine
//
//  Created by O2.LinYi on 16/3/22.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

let O2ContainerTransitionEndNotification = "Notification.ContainerTransitionEnd"
let O2InteractionEndNotification = "Notification.InteractionEnd"

class O2ContainerTransitionContext: NSObject, UIViewControllerContextTransitioning {
  
  // addtive property
  var animationController: UIViewControllerAnimatedTransitioning?
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
      // 每次转场开始调整 toView 的尺寸
      privateToVC.view.frame = privateContainerView.bounds
  }
  
  // 启动交互式转场
  func startInteractiveTransitionWith(delegate: ContainerViewControllerDelegate) {
    
    animationController = delegate.containerController(privateContainerVC, animationControllerForTransitionFromViewController: privateFromeVC, toViewController: privateToVC)
    transitionDuration = animationController!.transitionDuration(self)
    if privateContainerVC.interactive == true {
      if let interactionController = delegate.containerController?(privateContainerVC, interactionControllerForAnimation: animationController!) {
        interactionController.startInteractiveTransition(self)
      } else {
        fatalError("Need for interaction controller for interactive transition.")
      }
    } else {
      fatalError("ContainerTransitionContext's Property 'interactive' must be true before starting interactive transiton")
    }
  }
  
  // 启动非交互式转场
  func startNonInteractiveTransitionWith(delegate: ContainerViewControllerDelegate) {
    animationController = delegate.containerController(privateContainerVC, animationControllerForTransitionFromViewController: privateFromeVC, toViewController: privateToVC)
    transitionDuration = animationController!.transitionDuration(self)
    activateNonInteractiveTransition()    
  }
  
  // 交互控制器开始时会调用这个方法
  func activateInteractiveTransition() {
    interactive = true
    isCancelled = false
    privateContainerVC.addChildViewController(privateToVC)
    privateContainerView.layer.speed = 0
    animationController?.animateTransition(self)
  }
  // 非交互控制器初始方法
  func activateNonInteractiveTransition() {
    interactive = false
    isCancelled = false
    
    privateContainerVC.addChildViewController(privateToVC)
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
      privateFromeVC.willMoveToParentViewController(nil)
      privateFromeVC.view.removeFromSuperview()
      privateFromeVC.removeFromParentViewController()
    } else {
      privateToVC.didMoveToParentViewController(privateContainerVC)
      privateToVC.willMoveToParentViewController(nil)
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
      // 变化scrollView
      // MARK: - to add   to percentComplete
      privateContainerVC.graduallyChangeScrollViewWith(fromIndex, toIndex: toIndex, percent: percentComplete)
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
    
    let displayLink = CADisplayLink(target: self, selector: "finishChangeScrollView:")
    displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
    
  }
  
  func cancelInteractiveTransition() {
    interactive = false
    isCancelled = true
    let displayLink = CADisplayLink(target: self, selector: "reverseCurrentAnimation:")
    displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
    NSNotificationCenter.defaultCenter().postNotificationName(O2InteractionEndNotification, object: self)
  }
  
  func transitionWasCancelled() -> Bool {
    return isCancelled
  }
  
  // MARK: - add methods
  
  func reverseCurrentAnimation(displayLink : CADisplayLink) {
    let timeOffset = privateContainerView.layer.timeOffset - displayLink.duration
    if timeOffset > 0.00000 {
      
      privateContainerView.layer.timeOffset = timeOffset
      transitionPercent = CGFloat(timeOffset / transitionDuration)
    
      // 变化scrollView
      // MARK: - to add  to transitionPercent
      privateContainerVC.graduallyChangeScrollViewWith(fromIndex, toIndex: toIndex, percent: transitionPercent)
    } else {
      displayLink.invalidate()
      privateContainerView.layer.timeOffset = 0
      privateContainerView.layer.fillMode = kCAFillModeBackwards
      print(privateContainerView.layer.speed)
      privateContainerView.layer.speed = 1
      // 变化scrollView
      // MARK: - to add   to 0
      privateContainerVC.graduallyChangeScrollViewWith(fromIndex, toIndex: toIndex, percent: 0)
      
      //修复闪屏BUG
      let fakeFromeView = privateFromeVC.view.snapshotViewAfterScreenUpdates(false)
      privateContainerView.addSubview(fakeFromeView)
      performSelector("removeFakeFromView:", withObject: fakeFromeView, afterDelay: 1/60)
    }
  }
  
  func removeFakeFromView(fakeView: UIView) {
    fakeView.removeFromSuperview()
  }
  
  func finishChangeScrollView(displayLink: CADisplayLink) {
    let percentFrame = 1 / (transitionDuration * 60)
    transitionPercent += CGFloat(percentFrame)
    
    if transitionPercent < 1.0 {
      // 变化scrollView
      // MARK: - to add   to transitionPercent
      privateContainerVC.graduallyChangeScrollViewWith(fromIndex, toIndex: toIndex, percent: transitionPercent)
    } else {
      // 变化scrollView
      // MARK: - to add   to 1
      privateContainerVC.graduallyChangeScrollViewWith(fromIndex, toIndex: toIndex, percent: 1)
      displayLink.invalidate()
    }
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
