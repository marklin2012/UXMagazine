//
//  ViewController.swift
//  UXMagazine
//
//  Created by O2.LinYi on 16/2/14.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
//    let datas = {
//        for index in 1...5 {
//            
//        }
//    }()
    
    var image : UIImage?
    
    
    var stretchableTableHeaderView: O2StrechableTableHeaderView?
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let header = UIImageView(image: UIImage(named: "header"))
        tableView.tableHeaderView = header
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        firstLoading()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Custom function
    
    func firstLoading() {
        // 若第一次登录
        let storyboard = UIStoryboard(name: "FirstGuide", bundle: nil)
        let firstGuide = storyboard.instantiateViewControllerWithIdentifier("firstGuide") as! FirstGuideViewController
        let snapshot = view.snapshotViewAfterScreenUpdates(true)
        image = imageFormView(snapshot)
        firstGuide.backgroundImage = image
        
        presentViewController(firstGuide, animated: false, completion: nil)
    }
    
}

// MARK: - TableView Datasource and Delegate
extension ViewController : UITableViewDataSource, UIScrollViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellId = "cellId"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellId)
        }
        
        return cell!
    }
}

