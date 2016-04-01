//
//  ViewController.swift
//  UXMagazine
//
//  Created by O2.LinYi on 16/2/14.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

class ViewController: BaseViewController {
  
  private let HomeChoiceCellIdentifier = "HomeChoiceCell"
  
  @IBOutlet weak var tableView: UITableView!
  
  var datas : [HomeChoiceNews] = {
    var datas = [HomeChoiceNews]()
    for i in 0 ..< 10 {
      let model = HomeChoiceNews()
      datas.append(model)
    }
    
    return datas
  }()
  
  var image : UIImage?
  
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
    return datas.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(HomeChoiceCellIdentifier) as! HomeChoiceCell
    
    var model = datas[indexPath.row]
    model.summary = "这是国外基于5000多份对前端工程师问卷的统计结果，从中可以很容易的看出前端工程师的开发习惯以及前端各种工具类库的发展趋势。"
    cell.configure(withDataSource: model)
    
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    var model = datas[indexPath.row]
    model.summary = "testsss"
  }
  
  func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 178
  }
  
}
