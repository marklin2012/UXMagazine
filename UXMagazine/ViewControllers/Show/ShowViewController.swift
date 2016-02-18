//
//  ShowViewController.swift
//  UXMagazine
//
//  Created by O2.LinYi on 16/2/14.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

class ShowViewController: UIViewController, UIScrollViewDelegate {
    
    
    
    @IBOutlet weak var scrollViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var uxlogoCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var uxlogoImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var enterBtn: UIButton!
    @IBOutlet weak var o2Logo: UIImageView!
    @IBOutlet weak var o2Logo2: UIImageView!
    
    private var contents = [UIView]()
    private let ContentTag = 100
    private var animationGroup: CAAnimationGroup?
    private var displayLink: CADisplayLink?
    
    //comman value
    private let ScrollHeight: CGFloat = 400
    private let logoOffsetY: CGFloat = 80.0
    private let titleFont: CGFloat = 14.0
    private let labelHeight: CGFloat = 20.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configScrollView()
        configEnterButton()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        makeAnimation()
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        destoryWaveAnimations()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Animation
    private func makeAnimation() {
        //uxlogo向上偏移后再移入scrollView和pageControl
        UIView.animateWithDuration(1, animations: { [weak self] () -> Void in
            guard let strongSelf = self else {
                return
            }
            var rect = strongSelf.uxlogoImageView.frame
            rect.origin.y -= strongSelf.logoOffsetY
            strongSelf.uxlogoImageView.frame = rect
            
            strongSelf.uxlogoImageView.layoutIfNeeded()
            }, completion: { [weak self] (finished) -> Void in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.presentPageControlAndScrollView()
        })
    }
    
    private func presentPageControlAndScrollView() {
        UIView.animateWithDuration(0.5) { [weak self] () -> Void in
            guard let strongSelf = self else {
                return
            }
            strongSelf.pageControl.alpha = 1
            
            
            
            var rect = strongSelf.scrollView.frame
            
            rect.origin.x = 0
            
            strongSelf.scrollView.frame = rect
            
            strongSelf.scrollViewLeadingConstraint.constant = 0
            
            strongSelf.scrollView.layoutIfNeeded()
        }
    }
    
    // MARK: - Wave Animation
    private func makeWaveAnimation() {
        displayLink = CADisplayLink(target: self, selector: "delayWaveAnimation")
        displayLink?.frameInterval = 80
        displayLink?.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
    }
    
    func delayWaveAnimation() {
        startWaveAnimation()
    }
    
    private func startWaveAnimation() {
        let layer = CALayer()
        layer.cornerRadius = 50
        layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        layer.position = CGPointMake(enterBtn.frame.origin.x+25.0, enterBtn.frame.origin.y+25.0)
        layer.borderWidth = 1
        layer.borderColor = UIColor.whiteColor().CGColor
        view.layer.addSublayer(layer)
        
        let defaultCureve = CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)
        
        animationGroup = CAAnimationGroup()
        animationGroup?.delegate = self
        animationGroup?.duration = 4
        animationGroup?.removedOnCompletion = true
        animationGroup?.timingFunction = defaultCureve
        
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        scaleAnimation.fromValue = 0.5
        scaleAnimation.toValue = 1
        scaleAnimation.duration = 4
        
        let opencityAnimation = CAKeyframeAnimation(keyPath: "opacity")
        opencityAnimation.duration = 4
        opencityAnimation.values = [0.6, 0.4, 0]
        opencityAnimation.keyTimes = [0, 0.5, 1]
        opencityAnimation.removedOnCompletion = true
        
        animationGroup?.animations = [scaleAnimation, opencityAnimation]
        layer.addAnimation(animationGroup!, forKey: nil)
        
        performSelector("removeLayer:", withObject: layer, afterDelay: 3.5)
        
    }
    
    func removeLayer(layer: CALayer) {
        layer.removeFromSuperlayer()
    }
    
    func destoryWaveAnimations() {
        view.layer.removeAllAnimations()
        displayLink?.invalidate()
        displayLink = nil
    }
    
    // MARK: - init
    private func configEnterButton() {
        enterBtn.layer.cornerRadius = 25
        enterBtn.layer.borderColor = UIColor.whiteColor().CGColor
        enterBtn.layer.borderWidth = 1
    }
    
    private func configScrollView() {
        let viewA = contentA()
        let viewB = contentB()
        let viewC = contentC()
        let viewD = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: ScrollHeight))
        
        contents = [viewA, viewB, viewC, viewD]
        
        for index in 0..<contents.count {
            let innerView = contents[index]
            var center = innerView.center
            center.x += innerView.frame.size.width * CGFloat(index)
            innerView.center = center
            innerView.tag = ContentTag + index
            scrollView.addSubview(innerView)
        }
        
        scrollView.contentSize = CGSizeMake(UIScreen.mainScreen().bounds.size.width * CGFloat(contents.count), ScrollHeight)
        scrollView.pagingEnabled = true
        
    }
    
    private func configAlphaOfEveryInnerView(index: Int) {
        let inner = contents[index]
        let dx = scrollView.contentOffset.x - inner.frame.origin.x
        inner.alpha = 1 - dx / (scrollView.frame.size.width - 0)
    }
    
    // MARK: - ScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let index = scrollView.contentOffset.x/scrollView.frame.size.width
        //未滑动到最后一页
        if index <= 2.000 {
            configAlphaOfEveryInnerView(Int(index))
        } else {   //滑动到最后一页
            let inner = contents[2]
            let dx = scrollView.contentOffset.x - inner.frame.origin.x
            let alpha = dx / (scrollView.frame.size.width - 0)
            //视图的变化，根据偏移量来获得
            inner.alpha = 1 - alpha
            o2Logo.alpha = 1 - alpha
            pageControl.alpha = 1 - alpha
            enterBtn.alpha = alpha
            o2Logo2.alpha = alpha
            uxlogoCenterConstraint.constant = -logoOffsetY + logoOffsetY * alpha
        }
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x/scrollView.frame.size.width)
        switch index {
        case 0, 1, 2:
            pageControl.currentPage = index
        default: //滑动到第四屏时
            
            uxlogoCenterConstraint.constant = 0
            scrollView.removeFromSuperview()
            pageControl.removeFromSuperview()
            makeWaveAnimation()
        }
        
    }
    
    // MARK: - Custom inner view
    private func contentA() -> UIView {
        let content = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: content.frame.size.width, height: labelHeight))
        label.text = "一款可以让您浏览到业界最新资讯额应用"
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(titleFont)
        label.textAlignment = NSTextAlignment.Center
        label.center = CGPointMake(content.frame.size.width/2, content.frame.size.height/2)
        content.addSubview(label)
        return content
    }
    
    private func contentB() -> UIView {
        let content = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height))
        let labelA = UILabel(frame: CGRect(x: 0, y: 0, width: content.frame.size.width, height: labelHeight))
        labelA.text = "编辑搜罗您最爱的内容"
        labelA.textColor = UIColor.whiteColor()
        labelA.font = UIFont.systemFontOfSize(titleFont)
        labelA.textAlignment = NSTextAlignment.Center
        labelA.center = CGPointMake(content.frame.size.width/2, content.frame.size.height/2 - labelHeight/2)
        
        content.addSubview(labelA)
        
        let labelB = UILabel(frame: CGRect(x: 0, y: 0, width: content.frame.size.width, height: labelHeight))
        labelB.text = "根据您的兴趣提供按主题分类的文章"
        labelB.textColor = UIColor.whiteColor()
        labelB.font = UIFont.systemFontOfSize(titleFont)
        labelB.textAlignment = NSTextAlignment.Center
        labelB.center = CGPointMake(content.frame.size.width/2, content.frame.size.height/2 + labelHeight/2)
        content.addSubview(labelB)
        
        return content
    }
    
    private func contentC() -> UIView {
        let content = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: UIScreen.mainScreen().bounds.size.height))
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: content.frame.size.width, height: labelHeight))
        label.text = "内容每周更新与世界同步"
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(titleFont)
        label.textAlignment = NSTextAlignment.Center
        label.center = CGPointMake(content.frame.size.width/2, content.frame.size.height/2)
        content.addSubview(label)
        return content
    }
    
    @IBAction func enterAction() {
        if let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate {
            appDelegate.startMainStoryboard()
        }
    }

    
    
    

}
