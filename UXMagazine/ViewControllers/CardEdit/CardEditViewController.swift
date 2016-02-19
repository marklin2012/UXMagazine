//
//  CardEditViewController.swift
//  UXMagazine
//
//  Created by O2.LinYi on 16/2/17.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

class CardEditViewController: UIViewController {

    @IBOutlet weak var channelCollectionView: JDDragAndDropCollectionView!
    
    @IBOutlet weak var selectedCollectionView: JDDragAndDropCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func configCollectionView() {
        let channelFlowLayout = UICollectionViewFlowLayout()
        channelFlowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        channelFlowLayout.itemSize = CGSizeMake(126, 172)
        channelFlowLayout.minimumLineSpacing = 20
        channelFlowLayout.minimumInteritemSpacing = 50
        
        channelCollectionView.collectionViewLayout = channelFlowLayout
        
        //register
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func confirmAction() {
        dismissViewControllerAnimated(true, completion: nil)
    }

}
