//
//  HomeChoiceCell.swift
//  UXMagazine
//
//  Created by O2.LinYi on 16/2/23.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

class HomeChoiceCell: UITableViewCell {

    @IBOutlet weak var backImageView: UIImageView!
    
    @IBOutlet weak var newTitleLabel: UILabel!
    
    @IBOutlet weak var summaryLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
