//
//  FirstGuideViewController.swift
//  UXMagazine
//
//  Created by O2.LinYi on 16/2/17.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

class FirstGuideViewController: UIViewController {

    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    @IBOutlet weak var titleCenterYConstraint: NSLayoutConstraint!
    var backgroundImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        makeBlurAnimation()
        
    }
    
    private func makeBlurAnimation() {
        backImage.image = backgroundImage
        UIView.animateWithDuration(2, animations: { [weak self] () -> Void in
            guard let strongSelf = self else {
                return
            }
            strongSelf.blurView.alpha = 1
            }, completion: { [weak self] (finished) -> Void in
                guard let strongSelf = self else {
                    return
                }
                //模糊效果实现完，实现label动画
                strongSelf.makeTextAnimation()
            })
    }
    
    private func makeTextAnimation() {
        
        let option = UIViewAnimationOptions.CurveEaseOut
        UIView.animateWithDuration(1.5, delay: 0, options: option, animations: { [weak self] () -> Void in
            guard let strongSelf = self else {
                return
            }
            var rect = strongSelf.titleLabel.frame
            rect.origin.y -= 40
            strongSelf.titleLabel.frame = rect
            strongSelf.titleLabel.layoutIfNeeded()
            strongSelf.titleLabel.alpha = 1
            
            }, completion: { [weak self] (finished) -> Void in
                guard let strongSelf = self else {
                    return
                }
                
                strongSelf.makeSubTitleAnimation()
                
            })
    }
    
    private func makeSubTitleAnimation() {
        let option = UIViewAnimationOptions.CurveEaseOut
        UIView.animateWithDuration(0.5, delay: 0, options: option, animations: { [weak self] () -> Void in
            guard let strongSelf = self else {
                return
            }
            var rect = strongSelf.subTitleLabel.frame
            rect.origin.y -= 12
            strongSelf.subTitleLabel.frame = rect
            strongSelf.subTitleLabel.layoutIfNeeded()
            strongSelf.subTitleLabel.alpha = 1
            
            }, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
