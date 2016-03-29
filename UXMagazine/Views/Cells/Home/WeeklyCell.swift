//
//  WeeklyCell.swift
//  UXMagazine
//
//  Created by O2.LinYi on 16/3/24.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

class WeeklyCell: UITableViewCell {
    
    private let animationDuration = 1.0
    private let borderColor = UIColor(red: 151/255.0, green: 151/255.0, blue: 151/255.0, alpha: 1)
    
    @IBOutlet weak var order: UILabel!
    
    var cellColor : UIColor = UIColor.clearColor()
    
    var readed: Bool = false {
        willSet {
            if newValue {
                setupOrderColor()
            } else {
                setupOrderBorder()
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupOrderBorder()
    }
    
    // MARK: - further methods
    func setupOrderBorder() {
        order.layer.borderWidth = 1
        order.layer.borderColor = borderColor.CGColor
        order.backgroundColor = UIColor.clearColor()
        order.textColor = borderColor
    }
    
    func setupOrderColor() {
        UIView.animateWithDuration(animationDuration) { () -> Void in
            self.order.layer.borderWidth = 0
            self.order.backgroundColor = self.cellColor
            self.order.textColor = UIColor.whiteColor()
        }
        
        
    }
    
    
    
}
