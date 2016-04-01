//
//  O2PercentDrivenInteractiveTransition.swift
//  UXMagazine
//
//  Created by O2.LinYi on 16/3/30.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

class O2PercentDrivenInteractiveTransition: NSObject, UIViewControllerInteractiveTransitioning {
  weak var containerTransitionContext: O2ContainerTransitionContext?
  
  func startInteractiveTransition(transitionContext: UIViewControllerContextTransitioning) {
    if let context = transitionContext as? O2ContainerTransitionContext {
      containerTransitionContext = context
      containerTransitionContext?.activateInteractiveTransition()
    } else {
      fatalError("\(transitionContext) is not class or subclass of containerTransitionContext")
    }
    
  }
  
  func updateInteractiveTransition(percentComplete: CGFloat) {
    containerTransitionContext?.updateInteractiveTransition(percentComplete)
  }
  func cancelInteractiveTransition() {
    containerTransitionContext?.cancelInteractiveTransition()
  }
  
  func finishInteractiveTransition() {
    containerTransitionContext?.finishInteractiveTransition()
  }
  
  
  
}
