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
    
    // cell identifier
    private let CardChannelCellIdentifier = "CardChannelCell"
    private let CardSelectedCellIdentifier = "CardSelectedCell"
    
    //测试图片
    lazy var images: [UIImage] = {
        var imgs = [UIImage]()
        for index in 1...9 {
            let img = UIImage(named: "\(index)")
            imgs.append(img!)
        }
        return imgs
    }()
    
    lazy var otherImages: [UIImage] = {
        var imgs = [UIImage]()
        for index in 10...12 {
            let img = UIImage(named: "\(index)")
            imgs.append(img!)
        }
        return imgs
    }()
    
    var dragAndDropManager: JDDragAndDropManager?
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configCollectionView()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Custom function
    func configCollectionView() {
        let channelFlowLayout = UICollectionViewFlowLayout()
        channelFlowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        channelFlowLayout.itemSize = CGSizeMake(126, 172)
        channelFlowLayout.minimumLineSpacing = 20
        channelFlowLayout.minimumInteritemSpacing = 50
        
        channelCollectionView.collectionViewLayout = channelFlowLayout
        
        let selectFlowLayout = CardEditSelectedCollectionViewFlowLayout()
        selectFlowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
        selectFlowLayout.itemSize = CGSizeMake(126, 172)
        selectFlowLayout.minimumLineSpacing = 20
        selectFlowLayout.minimumInteritemSpacing = 50
        
        selectedCollectionView.collectionViewLayout = selectFlowLayout
        
        
        channelCollectionView.registerNib(UINib(nibName: CardChannelCellIdentifier, bundle: nil), forCellWithReuseIdentifier: CardChannelCellIdentifier)
        selectedCollectionView.registerNib(UINib(nibName: CardSelectedCellIdentifier, bundle: nil), forCellWithReuseIdentifier: CardSelectedCellIdentifier)
        
        dragAndDropManager = JDDragAndDropManager(acanvas: view, collectionViews: [channelCollectionView, selectedCollectionView])
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }

    @IBAction func confirmAction() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
   
    

}

// MARK: UICollectionView DataSource and Delegate
extension CardEditViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == channelCollectionView {
            return images.count
        } else {
            return otherImages.count
        }
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView == channelCollectionView {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CardChannelCellIdentifier, forIndexPath: indexPath) as! CardChannelCell
            cell.channelImageView.image = images[indexPath.row]
            cell.hidden = false
            if let jdCollectionView = collectionView as? JDDragAndDropCollectionView {
                if let draggingPathOfCellBeingDragged = jdCollectionView.draggingPathOfCellBeingDragged {
                    if draggingPathOfCellBeingDragged.item == indexPath.item {
                        cell.hidden = true
                    }
                }
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CardSelectedCellIdentifier, forIndexPath: indexPath) as! CardSelectedCell
            cell.cardImageView.image = otherImages[indexPath.row]
            cell.hidden = false
            if let jdCollectionView = collectionView as? JDDragAndDropCollectionView {
                if let draggingPathOfCellBeingDragged = jdCollectionView.draggingPathOfCellBeingDragged {
                    if draggingPathOfCellBeingDragged.item == indexPath.item {
                        cell.hidden = true
                    }
                }
            }
            return cell
        }
    }
}

extension CardEditViewController : JDDragAndDropCollectionViewDataSource {
    
    // MARK: - JDDragAndDropCollectionViewDataSource
    func collectionView(collectionView: UICollectionView, dataItemForIndexPath indexPath: NSIndexPath) -> AnyObject {
        if collectionView == channelCollectionView {
            return images[indexPath.row]
        } else {
            return otherImages[indexPath.row]
        }
    }
    //插入操作
    func collectionView(collectionView: UICollectionView, insertDataItem dataItem: AnyObject, atIndexPath indexPath: NSIndexPath) {
        if let di = dataItem as? UIImage {
            if collectionView == channelCollectionView {
                images.insert(di, atIndex: indexPath.item)
            } else {
                otherImages.insert(di, atIndex: indexPath.item)
            }
        }
    }
    
    //删除操作
    func collectionView(collectionView: UICollectionView, deleteDataItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView == channelCollectionView {
            images.removeAtIndex(indexPath.item)
        } else {
            otherImages.removeAtIndex(indexPath.item)
        }
    }
    
    //交换操作
    func collectionView(collectionView: UICollectionView, moveDataItemFromIndexPath form: NSIndexPath, toIndexPath to: NSIndexPath) {
        if collectionView == channelCollectionView {
            let fromDataItem = images[form.item]
            images.removeAtIndex(form.item)
            images.insert(fromDataItem, atIndex: to.item)
        } else {
            let formDataItem = images[form.item]
            otherImages.removeAtIndex(form.item)
            otherImages.insert(formDataItem, atIndex: to.item)
        }
    }
    
    //数据源操作
    func collectionview(collectionView: UICollectionView, indexPathForDataItem dataItem: AnyObject) -> NSIndexPath? {
        if let candidate = dataItem as? UIImage {
            if collectionView == channelCollectionView {
                for item: UIImage in images {
                    if candidate == item {
                        let position = images.indexOf(item)
                        let indexPath = NSIndexPath(forItem: position!, inSection: 0)
                        return indexPath
                    }
                }//for
            } else {
                for item: UIImage in otherImages {
                    if candidate == item {
                        let position = otherImages.indexOf(item)
                        let indexPath = NSIndexPath(forItem: position!, inSection: 0)
                        return indexPath
                    } // if candidate == item
                }// for
            }//  else
        }
        return nil
    }
}
