//
//  JDDragAndDropCollectionView.swift
//  CardEditDemo
//
//  Created by O2.LinYi on 16/1/19.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

@objc protocol JDDragAndDropCollectionViewDataSource : UICollectionViewDataSource {
    func collectionview(collectionView: UICollectionView, indexPathForDataItem dataItem: AnyObject) -> NSIndexPath?
    func collectionView(collectionView: UICollectionView, dataItemForIndexPath indexPath: NSIndexPath) -> AnyObject
    
    func collectionView(collectionView: UICollectionView, moveDataItemFromIndexPath form: NSIndexPath, toIndexPath to: NSIndexPath) -> Void
    
    func collectionView(collectionView: UICollectionView, insertDataItem dataItem:AnyObject, atIndexPath indexPath: NSIndexPath) -> Void
    
    func collectionView(collectionView: UICollectionView, deleteDataItemAtIndexPath indexPath: NSIndexPath) -> Void
}

class JDDragAndDropCollectionView: UICollectionView, JDDraggable, JDDroppable {
    
    var draggingPathOfCellBeingDragged: NSIndexPath?
    
//    var iDataSource: UICollectionViewDataSource?
//    var iDelegate: UICollectionViewDelegate?
    
    var animating: Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }

    
    // MARK: - JDDraggable
    func canDragAtPoint(point: CGPoint) -> Bool {
        guard let _ = dataSource as? JDDragAndDropCollectionViewDataSource else {
            return false
        }
        
        return indexPathForItemAtPoint(point) != nil
    }
    
    func representationImageAtPoint(point: CGPoint) -> UIView {
        var imageView: UIView?
        
        if let indexPath = indexPathForItemAtPoint(point) {
            let cell = cellForItemAtIndexPath(indexPath)!
            
            imageView = cell.snapshotViewAfterScreenUpdates(true)
            imageView?.frame = cell.frame
        }
        
        return imageView!
        
    }
    
    func dataItemAtPoint(point: CGPoint) -> AnyObject? {
        var dataItem: AnyObject?
        if let indexPath = indexPathForItemAtPoint(point) {
            if let dragDropDS : JDDragAndDropCollectionViewDataSource = self.dataSource as? JDDragAndDropCollectionViewDataSource {
                dataItem = dragDropDS.collectionView(self, dataItemForIndexPath: indexPath)
            }
        }
        return dataItem
    }
    
    func startDraggingAtPoint(point: CGPoint) {
        draggingPathOfCellBeingDragged = indexPathForItemAtPoint(point)
        reloadData()
    }
    
    func stopDragging() {
        if let idx = draggingPathOfCellBeingDragged {
            if let cell = cellForItemAtIndexPath(idx) {
                cell.hidden = false
            }
        }
        
        
        draggingPathOfCellBeingDragged = nil
        reloadData()
    }
    
    func dragDataItem(item: AnyObject) {
        if let dragDropDataSource = dataSource as? JDDragAndDropCollectionViewDataSource {
            if let existingIndexPath = dragDropDataSource.collectionview(self, indexPathForDataItem: item) {
                dragDropDataSource.collectionView(self, deleteDataItemAtIndexPath: existingIndexPath)
                animating = true
                
                performBatchUpdates({ [weak self] () -> Void in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.deleteItemsAtIndexPaths([existingIndexPath])
                    }, completion: { [weak self] (complete) -> Void in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.animating = false
                        strongSelf.reloadData()
                })
            }//if let existingIndexPath ...
        }//if let dragDropDataSource ...
    }
    
    // MARK: - JDDroppable
    
    var isHorizontal : Bool {
        return (self.collectionViewLayout as? UICollectionViewFlowLayout)?.scrollDirection == .Horizontal
    }
    var paging : Bool = false
    
    func canDropAtRect(rect: CGRect) -> Bool {
        return indexPathForCellOverlappingRect(rect) != nil
    }
    
    func indexPathForCellOverlappingRect(rect: CGRect) -> NSIndexPath? {
        var overlappingArea: CGFloat = 0
        var cellCandidate: UICollectionViewCell?
        
        let visibleCells = self.visibleCells()
        
        if visibleCells.count == 0 {
            return NSIndexPath( forItem: 0, inSection: 0)
        }
        
        if isHorizontal && rect.origin.x > contentSize.width ||
            !isHorizontal && rect.origin.y > contentSize.height {
                return NSIndexPath(forItem: visibleCells.count - 1, inSection: 0)
        }
        
        for visible in visibleCells {
            let intersection = CGRectIntersection(visible.frame, rect)
            
            if intersection.width * intersection.height > overlappingArea {
                overlappingArea = intersection.width * intersection.height
                cellCandidate = visible
            }
        }
        
        if let cellRetriveved = cellCandidate {
            return indexPathForCell(cellRetriveved)
        }
        
        return nil
    }
    
    private var currentInRect: CGRect?
    func willMoveItem(item: AnyObject, inRect rect: CGRect) {
        let dragDropDataSource = dataSource as! JDDragAndDropCollectionViewDataSource
        if let _ = dragDropDataSource.collectionview(self, indexPathForDataItem: item) { // if data item exists
            return
        }
        
        if let indexPath = indexPathForCellOverlappingRect(rect) {
            dragDropDataSource.collectionView(self, insertDataItem: item, atIndexPath: indexPath)
            
            draggingPathOfCellBeingDragged = indexPath
            animating = true
            
            performBatchUpdates({ [weak self] () -> Void in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.insertItemsAtIndexPaths([indexPath])
                }, completion: { [weak self] (complete) -> Void in
                    guard let strongSelf = self else {
                        return
                    }
                    strongSelf.animating = false
                    
                    //if in the meantime we have let go
                    if strongSelf.draggingPathOfCellBeingDragged == nil {
                        strongSelf.reloadData()
                    }
            })// performBatchUpdates ...
        }// if let indexPath ...
        
        currentInRect = rect
    }
    
    
    func checkForEdgesAndScroll(rect: CGRect) -> Void {
        if paging == true {
            return
        }
        
        let currentRect = CGRectMake(contentOffset.x, contentOffset.y, bounds.size.width, bounds.size.height)
        var rectForNextScroll = currentRect
        
        if isHorizontal {
            let leftBoundary = CGRectMake(-30, 0, 30, frame.size.height)
            let rightBoundary = CGRectMake(frame.size.width, 0, 30, frame.size.height)
            
            if CGRectIntersectsRect(rect, leftBoundary) {
                rectForNextScroll.origin.x -= bounds.size.width * 0.5
                if rectForNextScroll.origin.x < 0 {
                    rectForNextScroll.origin.x = 0
                }
            } else if CGRectIntersectsRect(rect, rightBoundary) {
                rectForNextScroll.origin.x += bounds.size.width * 0.5
                if rectForNextScroll.origin.x > contentSize.width - bounds.size.width {
                    rectForNextScroll.origin.x = contentSize.width - bounds.size.width
                }
            }
        } else {
            //is vertical
            let topBoundary = CGRectMake(0, -30, frame.size.width, 30)
            let bottomBoundary = CGRectMake(0, frame.size.height, frame.size.width, 30)
            
            if CGRectIntersectsRect(rect, topBoundary) {
                
            } else if CGRectIntersectsRect(rect, bottomBoundary) {
                
            }
        }
        
        //check to see if a change in rectForNextScroll has been made 
        if !CGRectEqualToRect(currentRect, rectForNextScroll) {
            paging = true
            scrollRectToVisible(rectForNextScroll, animated: true)
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC)))
            dispatch_after(delayTime, dispatch_get_main_queue(), { () -> Void in
                self.paging = false
            })
        }// if !CGRectEqualToRect ...
    }
    
    func didMoveItem(item: AnyObject, inRect rect: CGRect) {
        let dragDropDS = dataSource as! JDDragAndDropCollectionViewDataSource
        
        if let existingIndexPath = dragDropDS.collectionview(self, indexPathForDataItem: item),
            let indexPath = indexPathForCellOverlappingRect(rect) {
                if indexPath.item != existingIndexPath.item {
                    dragDropDS.collectionView(self, moveDataItemFromIndexPath: existingIndexPath, toIndexPath: indexPath)
                    animating = true
                    
                    performBatchUpdates({ [weak self] () -> Void in
                        guard let strongSelf = self else {
                            return
                        }
                        strongSelf.moveItemAtIndexPath(existingIndexPath, toIndexPath: indexPath)
                        }, completion: { [weak self] (complete) -> Void in
                            guard let strongSelf = self else {
                                return
                            }
                            
                            strongSelf.animating = false
                            strongSelf.reloadData()
                    })
                    
                    draggingPathOfCellBeingDragged = indexPath
                } // if indexPath.item ...
        } // if let existingIndexPath ...
        
        // check paging
        
        var normalizedRect = rect
        normalizedRect.origin.x -= contentOffset.x
        normalizedRect.origin.y -= contentOffset.y
        
        currentInRect = normalizedRect
        
        checkForEdgesAndScroll(normalizedRect)
    }
    
    func didMoveOutItem(item: AnyObject) {
        guard let dragDropDataSource = dataSource as? JDDragAndDropCollectionViewDataSource else {
            return
        }
        
        guard let existingIndexPath = dragDropDataSource.collectionview(self, indexPathForDataItem: item) else {
            return
        }
        
        dragDropDataSource.collectionView(self, deleteDataItemAtIndexPath: existingIndexPath)
        animating = true
        
        performBatchUpdates({ [weak self] () -> Void in
            guard let strongSelf = self else {
                return
            }
            strongSelf.deleteItemsAtIndexPaths([existingIndexPath])
            }, completion: {[weak self] (complete) -> Void in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.animating = false
                strongSelf.reloadData()
        })
        
        if let idx = self.draggingPathOfCellBeingDragged {
            if let cell = cellForItemAtIndexPath(idx) {
                cell.hidden = false
            }
        }
        
        draggingPathOfCellBeingDragged = nil
        currentInRect = nil
    }
    
    func dropDataItem(item: AnyObject, atRect: CGRect) {
        //show hidden cell
        if let index = draggingPathOfCellBeingDragged,
            let cell = cellForItemAtIndexPath(index) where cell.hidden == true {
                cell.alpha = 1.0
                cell.hidden = false
        }
        
        currentInRect = nil
        draggingPathOfCellBeingDragged = nil
        reloadData()
    }
    
}
