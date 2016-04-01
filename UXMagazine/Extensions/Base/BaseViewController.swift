//
//  BaseViewController.swift
//  UXMagazine
//
//  Created by O2.LinYi on 16/3/30.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

protocol BaseViewControllerDelegate {
  func viewCtlScrollViewDidScroll(scrollView: UIScrollView)
  func viewCtlScrollViewDidEndDecelerating(scrollView: UIScrollView)
}

class BaseViewController: UIViewController {
  
  var baseDelegate: BaseViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

extension BaseViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(scrollView: UIScrollView) {
    baseDelegate?.viewCtlScrollViewDidScroll(scrollView)
  }
  
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    baseDelegate?.viewCtlScrollViewDidEndDecelerating(scrollView)
  }
  
  func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate {
      baseDelegate?.viewCtlScrollViewDidEndDecelerating(scrollView)
    }
  }
}
