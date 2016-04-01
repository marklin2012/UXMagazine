//
//  O2SlideAnimationController.swift
//  UXMagazine
//
//  Created by O2.LinYi on 16/3/30.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

enum TabOperationDirection {
  case Left
  case Right
}

enum ModalOperation {
  case Presentation
  case Dismissal
}

enum O2TransitionType {
  case NavigationTransition(UINavigationControllerOperation)
  case TabTransition(TabOperationDirection)
  case ModalTransition(ModalOperation)
}

class O2SlideAnimationController: UIPercentDrivenInteractiveTransition, UIViewControllerAnimatedTransitioning {
  private var transitionType: O2TransitionType
  private let animationDuration = 0.3
  
  weak var storedContext: UIViewControllerContextTransitioning?
  
  init(type: O2TransitionType) {
    transitionType = type
    super.init()
  }
  
  func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
    return animationDuration
  }
  
  func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
    
    guard let containerView = transitionContext.containerView(),
      fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
      toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey) else {
      return
    }
    
    
    let fromView = fromVC.view
    let toView = toVC.view
    
    var translation = containerView.frame.width
    var toViewTransform = CGAffineTransformIdentity
    var fromViewTransform = CGAffineTransformIdentity
    
    switch transitionType {
    case .NavigationTransition(let operation):
      translation = operation == .Push ? translation: -translation
      toViewTransform = CGAffineTransformMakeTranslation(translation, 0)
      fromViewTransform = CGAffineTransformMakeTranslation(-translation, 0)
    case .TabTransition(let direction):
      translation = direction == .Left ? translation: -translation
      toViewTransform = CGAffineTransformMakeTranslation(translation, 0)
      fromViewTransform = CGAffineTransformMakeTranslation(-translation, 0)
    case .ModalTransition(let operation):
      translation = containerView.frame.height
      toViewTransform = CGAffineTransformMakeTranslation(0, operation == .Presentation ? translation : 0)
      fromViewTransform = CGAffineTransformMakeTranslation(0, operation == .Presentation ? 0 : translation)
    }
    
    switch transitionType {
    case .ModalTransition(let operation):
      switch operation {
      case .Presentation:
        containerView.addSubview(toView)
      case .Dismissal:
        break
      }
    default: containerView.addSubview(toView)
    }
    
    toView.transform = toViewTransform
    
    UIView.animateWithDuration(animationDuration, animations: { () -> Void in
      fromView.transform = fromViewTransform
      toView.transform = CGAffineTransformIdentity
      }, completion: { _ in
        fromView.transform = CGAffineTransformIdentity
        toView.transform = CGAffineTransformIdentity
        
        let isCancelled = transitionContext.transitionWasCancelled()
        transitionContext.completeTransition(!isCancelled)
        
    })
  }
  
//  func handlePan(pan: UIPanGestureRecognizer, andProgress progress:CGFloat) {
////    let translation = pan.translationInView(pan.view!.superview!)
//    let rProgress = min(max(progress, 0.01), 0.99)
//    
//    switch pan.state {
//    case .Changed:
//      updateInteractiveTransition(rProgress)
//    case .Cancelled, .Ended:
////      let transitionLayel = storedContext!.containerView()!.layer
//      
//      if (progress < 0.5) {
//        completionSpeed = -1.0
//        cancelInteractiveTransition()
//      } else {
//        completionSpeed = 1.0
//        finishInteractiveTransition()
//      }
//    default: break
//    }
//  }
  
  
}
