//
//  O2StrechableTableHeaderView.swift
//  UXMagazine
//
//  Created by O2.LinYi on 16/2/16.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

public class O2StrechableTableHeaderView: NSObject {
    public var tableView: UITableView?
    public var headerView: UIView?
    
    private var initialFrame: CGRect?
    private var defaultViewHeight: CGFloat?
    
    public func stretchHeaderForTableView(aTableView: UITableView, withHeaderView wheadView:UIView) {
        tableView = aTableView
        headerView = wheadView
        
        initialFrame = headerView?.frame
        defaultViewHeight = initialFrame?.size.height
        
        let emptyTableHeaderView = UIView(frame: initialFrame!)
        tableView?.tableHeaderView = emptyTableHeaderView
        
        tableView?.addSubview(headerView!)
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        var f = headerView!.frame
        f.size.width = tableView!.frame.size.width
        headerView?.frame = f
        
        if scrollView.contentOffset.y < 0 {
            let offsetY = (scrollView.contentOffset.y + scrollView.contentInset.top) * -1
            initialFrame?.origin.y = offsetY * -1
            initialFrame?.size.height = defaultViewHeight! + offsetY
            headerView?.frame = initialFrame!
        }
    }
    
    public func resizeView() {
        initialFrame?.size.width = tableView!.frame.size.width
        headerView!.frame = initialFrame!
    }
}
