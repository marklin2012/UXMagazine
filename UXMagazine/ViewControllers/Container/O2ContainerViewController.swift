//
//  O2ContainerViewController.swift
//  UXMagazine
//
//  Created by O2.LinYi on 16/3/22.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit



@IBDesignable
class O2ContainerViewController: UIViewController {
  
  private let transitionDuration = 1.0
  
  private let HeaderImageHeight: CGFloat = 102
  
  /// 自定义控制器视图容器
  private let privateContainerview = UIView()
  
  private var shouldReserve = false
  
  private var priorSeletedIndex: Int = NSNotFound
  
  private var containerTransitionContext: O2ContainerTransitionContext?
  /// 转场动画代理
  weak var containerTransitionDelegate: ContainerViewControllerDelegate?
  
  private var headBar: HeaderTitleBar = {
    let header = HeaderTitleBar(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 102))
    return  header
  }()
  
  
  
  /// 自定义控制器数组
  var viewControllers: [UIViewController]?
  
  /// 滚动头视图图片数组
  var images: [UIImage]?
  
  /// 头部滑动视图
  var scrollView = UIScrollView()
  
  /// 是否可以交互
  var interactive = false
  
  
  
  /// 当前展示控制器下标
  var selectedIndex: Int = NSNotFound {
    willSet {
      if shouldReserve {
        shouldReserve = false
      } else {
        transitionViewControllerFromIndex(selectedIndex, toIndex: newValue)
      }
      
    }
  }
  
  // MARK: - LiftCycle
  override func loadView() {
    super.loadView()
    
    // init containerView
    privateContainerview.translatesAutoresizingMaskIntoConstraints = false
    privateContainerview.backgroundColor = UIColor.clearColor()
    view.addSubview(privateContainerview)
    view.addConstraint(NSLayoutConstraint(item: privateContainerview, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: privateContainerview, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: privateContainerview, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: privateContainerview, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
    
    // init scrollView
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.pagingEnabled = true
    scrollView.bounces = false
    scrollView.delegate = self
    scrollView.backgroundColor = UIColor.clearColor()
    view.addSubview(scrollView)
    view.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
    view.addConstraint(NSLayoutConstraint(item: scrollView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 0.3, constant: 0))
    
    // 实时更新autolayout的布局，否则后面子视图无法及时更新约束
    view.layoutIfNeeded()
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    
    // add observer
    NSNotificationCenter.defaultCenter().addObserverForName(O2ContainerTransitionEndNotification, object: nil, queue: nil, usingBlock: { _ in
      self.containerTransitionContext = nil
      
    })
    
    // add pangesture
    let panGesture = UIPanGestureRecognizer(target: self, action: "handlePan:")
    view.addGestureRecognizer(panGesture)
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  // MARK: - panGesture
  func handlePan(pan: UIPanGestureRecognizer) {
    if viewControllers == nil || viewControllers?.count < 2 || containerTransitionDelegate == nil  || !scrollView.scrollEnabled{
      return
    }
    
    let delegate = containerTransitionDelegate as! O2ContainerViewControllerDelegate
    let translationX = pan.translationInView(view).x
    let translationAbs = translationX > 0 ? translationX : -translationX
    let progress = translationAbs / view.frame.width
    print(progress)
    switch pan.state {
    case  .Began:
      interactive = true
      let velocityX = pan.velocityInView(view).x
      if velocityX < 0 {
        if selectedIndex < viewControllers!.count - 1 {
          selectedIndex += 1
        }
      } else {
        if selectedIndex > 0 {
          selectedIndex -= 1
        }
      }// if velocityX < 0 else
    case .Changed:
      delegate.interactionController.updateInteractiveTransition(progress)
    case .Cancelled, .Ended:

      interactive = false
      if progress > 0.5 {

        delegate.interactionController.finishInteractiveTransition()
        
      } else {
//        delegate.interactionController.completionSpeed = -1.0
        delegate.interactionController.cancelInteractiveTransition()
      }
      
    default: break
    }// switch pan.state
    
  }
  
  // MARK: - UI set up
  /**
  设置图片
  */
  func setupImages() {
    // for test
    images = [UIImage(named: "header")!, UIImage(named: "header1")!, UIImage(named: "header2")!]
  }
  
  /**
   初始化scrollView
   */
  func setupScrollViewImage() {
    
    setupImages()
    // MARK: - 设置图片个数，根据需要的时候修改
    for i in 0...2 {
      let rect = CGRect(x: 0 + view.frame.size.width * CGFloat(i), y: 0, width: view.frame.size.width, height: view.frame.size.height*0.3)
      
      let imageView = UIImageView(frame: rect)
      imageView.image = images![i]
      imageView.backgroundColor = UIColor.clearColor()
      scrollView.addSubview(imageView)
    }
    
    scrollView.contentSize = CGSizeMake(view.frame.size.width * 3, view.frame.size.height*0.3)
    scrollView.userInteractionEnabled = false
  }
  
  /**
   设置头视图按钮和渐变背景以上部分
   */
  func setupHeaderView() {
    view.addSubview(headBar)
    headBar.callSearch = {
      
    }
    
    headBar.callEdit = {
      
    }
    
    headBar.callInfo = {
      
    }
  }
  
  /**
   初始化UI
   */
  func setupUI() {
    
    setupScrollViewImage()
    
    // 设置视图顺序
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let rootViewCtl = storyboard.instantiateViewControllerWithIdentifier("rootCtl") as! ViewController
    rootViewCtl.baseDelegate = self
    
    let sub1 = BaseViewController()
    sub1.view.backgroundColor = UIColor.redColor()
    let ssss = UIScrollView(frame: CGRect(x: 0, y: 0, width: 200, height: 1000))
    ssss.backgroundColor = UIColor.blackColor()
    ssss.contentSize = CGSize(width: 200, height: 1000)
    ssss.delegate = sub1
    sub1.view.addSubview(ssss)
    sub1.baseDelegate = self
    
    let sub2 = UIViewController()
    sub2.view.backgroundColor = UIColor.yellowColor()
    
    viewControllers = [rootViewCtl, sub1, sub2]
    
    for childVC in viewControllers! {
      childVC.view.translatesAutoresizingMaskIntoConstraints = true
      childVC.view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
    }
    selectedIndex = 0
    
    setupHeaderView()
  }
  
  // MARK: - ScrollView methods
  func graduallyChangeScrollViewWith(fromIndex: Int, toIndex: Int, percent: CGFloat) {
    let dircetion: TabOperationDirection = toIndex > fromIndex ? .Left : .Right
    let startOffsetX = scrollView.frame.size.width * CGFloat(fromIndex)
    switch dircetion {
    case .Left:
      scrollView.contentOffset.x = startOffsetX + scrollView.frame.width * percent
    case .Right:
      scrollView.contentOffset.x = startOffsetX - scrollView.frame.width * percent
    }
  }
  
  
  // MARK: - further methods
  func restoreSelectedIndex() {
    shouldReserve = true
    selectedIndex = priorSeletedIndex
  }
  
  private func transitionViewControllerFromIndex(fromIndex: Int, toIndex: Int) {
    // 排除特殊情况
    if viewControllers == nil || fromIndex == toIndex || fromIndex < 0 || toIndex < 0 || toIndex >= viewControllers!.count || (fromIndex >= viewControllers!.count && fromIndex != NSNotFound){
      return
    }
    
    // 如果一开始未设置
    if fromIndex == NSNotFound {
      let selectedVC = viewControllers![toIndex]
      addChildViewController(selectedVC)
      privateContainerview.addSubview(selectedVC.view)
      selectedVC.didMoveToParentViewController(self)
      
      // change scrollView
      
      return
    }
    
    if containerTransitionDelegate != nil {
      
      
      let fromVC = viewControllers![fromIndex]
      let toVC = viewControllers![toIndex]
      containerTransitionContext = O2ContainerTransitionContext(containerViewController: self, containerView: privateContainerview, fromViewController: fromVC, toViewController: toVC)
      
      if interactive {
        priorSeletedIndex = fromIndex
        containerTransitionContext?.startInteractiveTransitionWith(containerTransitionDelegate!)
      } else {
        containerTransitionContext?.startNonInteractiveTransitionWith(containerTransitionDelegate!)
        // scrollView 做滚动
      }
      
      
    } else {
      // 添加toVC 和 toView
      let priorSelectedVC = viewControllers![fromIndex]
      priorSelectedVC.willMoveToParentViewController(nil)
      priorSelectedVC.view.removeFromSuperview()
      priorSelectedVC.removeFromParentViewController()
      
      
      
      let newSelectedVC = viewControllers![toIndex]
      
      addChildViewController(newSelectedVC)
      
      privateContainerview.addSubview(newSelectedVC.view)
      newSelectedVC.didMoveToParentViewController(self)

    }
  }// func
  
}

// MARK: - ScrollView Delegate
extension O2ContainerViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
    print(page)
    selectedIndex = page
  }
}

// MARK: - ViewControllerDelegate
extension O2ContainerViewController: BaseViewControllerDelegate {
  func viewCtlScrollViewDidScroll(scrollView: UIScrollView) {
    
    if (scrollView.contentOffset.y <= 0) {
      self.scrollView.hidden = true
    } else {
      self.scrollView.hidden = false
      
      // 头视图背景图片固定时位置
      let imagePositionY = -(self.scrollView.bounds.height - HeaderImageHeight)
      
      if scrollView.contentOffset.y > (self.scrollView.frame.height - HeaderImageHeight) * 2 && self.scrollView.frame.origin.y <= imagePositionY
      {
        if (self.scrollView.frame.origin.y != imagePositionY) {
          //偏移量超出时，头视图背景图片固定位置
          UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: { () -> Void in
            print("anim")
            self.scrollView.frame.origin.y = imagePositionY
            }, completion: nil)
        }
      } else {
        self.scrollView.frame.origin.y = 0 - scrollView.contentOffset.y * 0.5
      }// else
    }
  }
  
  func viewCtlScrollViewDidEndDecelerating(scrollView: UIScrollView) {
    // 如果不是在初始位置，不能滑动切换视图
    self.scrollView.scrollEnabled = (scrollView.contentOffset.y == 0) ? true : false
//    self.interactive = (scrollView.contentOffset.y == 0) ? true : false
    // 如果
    if scrollView.contentOffset.y < (self.scrollView.frame.height - HeaderImageHeight) * 2 {
      
      UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: [], animations: { () -> Void in
        scrollView.contentOffset.y = 0
        }, completion: { _ in
          self.scrollView.scrollEnabled = true
      })
    }
    
    self.scrollView.hidden = self.scrollView.scrollEnabled
    
  }
}
