//
//  ViewController.swift
//  UXMagazine
//
//  Created by O2.LinYi on 16/2/14.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

@objc protocol ViewControllerDelegate {
    optional func viewCtlScrollViewDidScroll(scrollView: UIScrollView)
    optional func viewCtlScrollViewDidEndDecelerating(scrollView: UIScrollView)
}

class ViewController: UIViewController {
    
    private let HomeChoiceCellIdentifier = "HomeChoiceCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    var image : UIImage?
    
    weak var delegate: ViewControllerDelegate?
    
    let header = UIImageView(image: UIImage(named: "header"))
    
    var stretchableTableHeaderView: O2StrechableTableHeaderView?
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header.frame.size.height = view.frame.size.height * 0.3
        tableView.tableHeaderView = header
        configTableView()

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
        
        let userDefault = NSUserDefaults.standardUserDefaults()
        
        
        if userDefault.integerForKey("FirstLoading") == 1 {
            // 非第一次登陆
        } else {
            // 若第一次登录
            let storyboard = UIStoryboard(name: "FirstGuide", bundle: nil)
            let firstGuide = storyboard.instantiateViewControllerWithIdentifier("firstGuide") as! FirstGuideViewController
            let snapshot = view.snapshotViewAfterScreenUpdates(true)
            image = imageFormView(snapshot)
            firstGuide.backgroundImage = image
            
            presentViewController(firstGuide, animated: false, completion: nil)
            
            // 记录第一次登陆值
            userDefault.setInteger(1, forKey: "FirstLoading")
            userDefault.synchronize()
        }
        
    }
    
    func configTableView() {
        tableView.registerNib(UINib(nibName: HomeChoiceCellIdentifier, bundle: nil), forCellReuseIdentifier: HomeChoiceCellIdentifier)
    }
    
}

// MARK: - TableView Datasource and Delegate
extension ViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(HomeChoiceCellIdentifier) as! HomeChoiceCell
        
        var model = HomeChoiceNews()
        model.summary = "这是国外基于5000多份对前端工程师问卷的统计结果，从中可以很容易的看出前端工程师的开发习惯以及前端各种工具类库的发展趋势。"
        cell.configure(withDataSource: model)
        
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 178
    }
    
}

extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        delegate?.viewCtlScrollViewDidScroll?(scrollView)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        delegate?.viewCtlScrollViewDidEndDecelerating?(scrollView)
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            delegate?.viewCtlScrollViewDidEndDecelerating?(scrollView)
        }
    }
    
}


