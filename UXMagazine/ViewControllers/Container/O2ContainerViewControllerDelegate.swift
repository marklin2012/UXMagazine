//
//  O2ContainerViewControllerDelegate.swift
//  UXMagazine
//
//  Created by O2.LinYi on 16/3/30.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

@objc protocol ContainerViewControllerDelegate{
  func containerController(containerController: O2ContainerViewController, animationControllerForTransitionFromViewController
    fromVC: UIViewController,
    toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
  optional func containerController(containerController: O2ContainerViewController, interactionControllerForAnimation
    animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning
  
}

class O2ContainerViewControllerDelegate: NSObject, ContainerViewControllerDelegate {
  var interactionController = O2PercentDrivenInteractiveTransition()
  
  
  func containerController(containerController: O2ContainerViewController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC:UIViewController) -> UIViewControllerAnimatedTransitioning? {
    let fromIndex = containerController.viewControllers!.indexOf(fromVC)
    let toIndex = containerController.viewControllers!.indexOf(toVC)
    //方向
    let tabChangeDirection: TabOperationDirection = toIndex > fromIndex ? .Left : .Right
    let transitionType = O2TransitionType.TabTransition(tabChangeDirection)
    let slideAnimationController = O2SlideAnimationController(type: transitionType)
    return slideAnimationController
    
  }
  
  func containerController(containerController: O2ContainerViewController, interactionControllerForAnimation
    animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning {
      return interactionController      
  }
  
}
