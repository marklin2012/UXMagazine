//
//  HeaderTitleBar.swift
//  UXMagazine
//
//  Created by O2.LinYi on 16/3/25.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

class HeaderTitleBar: UIView {
    /// 设置搜索按钮回调
    var callSearch: (() -> Void)?
    /// 设置编辑按钮回调
    var callEdit: (() -> Void)?
    /// 设置个人信息按钮回调
    var callInfo: (() -> Void)?
    
    
    /// 渐变透明背景
    private let gradientLayer : CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width, height: 102)
        gradient.colors = [UIColor.blackColor().CGColor, UIColor.clearColor().CGColor]
        return gradient
    }()
    
    @IBOutlet weak var channelLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var subDescriptionLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.addSublayer(gradientLayer)
        loadViewFromNib()
    }
    
    func loadViewFromNib() {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "HeaderTitleBar", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        view.frame = bounds
        addSubview(view)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
//        fatalError("init(coder:) has not been implemented")
    }
    
    
    @IBAction func didSearch() {
        callSearch?()
    }
    
    @IBAction func didEdit() {
        callEdit?()
    }
    
    @IBAction func didInfo() {
        callInfo?()
    }
    
    
    
}
