//
//  HomeChoiceCell.swift
//  UXMagazine
//
//  Created by O2.LinYi on 16/2/23.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

protocol HomeChoiceCellDataSource {
    var imageName: String { get }
    var title: String { get }
    var summary: String { get }
}

class HomeChoiceCell: UITableViewCell {
    @IBOutlet weak var bottomView: UIView!

    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    @IBOutlet weak var newTitleLabel: UILabel!
    
    @IBOutlet weak var summaryLabel: UILabel!
    
    private var dataSource: HomeChoiceCellDataSource?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = 10
        bottomView.layer.cornerRadius = 10
        bottomView.layer.shadowOpacity = 0.5
        bottomView.layer.shadowOffset = CGSize(width: 0, height: 2)
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(withDataSource dataSource: HomeChoiceCellDataSource) {
        self.dataSource = dataSource
        
        backImageView.image = UIImage(named: dataSource.imageName)
        newTitleLabel.text = dataSource.title
        summaryLabel.text = dataSource.summary
    }
    
}
