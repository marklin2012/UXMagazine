//
//  JDDragAndDropManager.swift
//  CardEditDemo
//
//  Created by O2.LinYi on 16/1/18.
//  Copyright © 2016年 jd.com. All rights reserved.
//

import UIKit

@objc protocol JDDraggable {
    func canDragAtPoint(point: CGPoint) -> Bool
    func representationImageAtPoint(point:CGPoint) -> UIView
    func dataItemAtPoint(point: CGPoint) -> AnyObject?
    func dragDataItem(item: AnyObject) -> Void
    optional func startDraggingAtPoint(point: CGPoint) -> Void
    optional func stopDragging() -> Void
}

@objc protocol JDDroppable {
    func canDropAtRect(rect: CGRect) -> Bool
    func willMoveItem(item: AnyObject, inRect rect:CGRect) -> Void
    func didMoveItem(item: AnyObject, inRect rect:CGRect) -> Void
    func didMoveOutItem(item: AnyObject) -> Void
    func dropDataItem(item: AnyObject, atRect: CGRect) -> Void
}

class JDDragAndDropManager: NSObject, UIGestureRecognizerDelegate {
    
    private var canvas: UIView = UIView()
    private var views: [UIView] = []
    private var longPress = UILongPressGestureRecognizer()
    
    struct Bundle {
        var offset : CGPoint = CGPointZero
        var sourceDraggableView: UIView
        var overDroppableView: UIView?
        var representationImageView: UIView
        var dataItem: AnyObject
    }
    
    var bundle: Bundle?
    
    init(acanvas: UIView, collectionViews: [UIView]) {
        super.init()
        canvas = acanvas
        longPress.delegate = self;
        longPress.minimumPressDuration = 0.3
        longPress.addTarget(self, action: "updateForLongPress:")
        canvas.addGestureRecognizer(longPress)
        views = collectionViews
        
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        for view in views.filter({ (v) -> Bool in v is JDDraggable }) {
            let draggable = view as! JDDraggable
            
            let touchPointInvView = touch.locationInView(view)
            
            if draggable.canDragAtPoint(touchPointInvView) {
                guard let representation: UIView = draggable.representationImageAtPoint(touchPointInvView) else {
                    return false
                }
                
                representation.frame = canvas.convertRect(representation.frame, fromView: view)
                representation.alpha = 0.7
                let pointOnCanvas = touch.locationInView(canvas)
                let offset = CGPointMake(pointOnCanvas.x - representation.frame.origin.x, pointOnCanvas.y - representation.frame.origin.y)
                
                guard let dataItem = draggable.dataItemAtPoint(touchPointInvView) else {
                    return false
                }
                
                bundle = Bundle(offset: offset, sourceDraggableView: view, overDroppableView: view is JDDraggable ? view : nil, representationImageView: representation, dataItem: dataItem)
                
                return true
                
            }
        }
        
        return false
    }
    
    func updateForLongPress(recogniser: UILongPressGestureRecognizer) -> Void {
        guard let bund = bundle else {
            return
        }
        
        let pointOnCanvas = recogniser.locationInView(recogniser.view)
        let sourceDraggable = bund.sourceDraggableView as! JDDraggable
        let pointOnSourceDraggable = recogniser.locationInView(bund.sourceDraggableView)
        
        switch recogniser.state {
        case .Began:
            canvas.addSubview(bund.representationImageView)
            sourceDraggable.startDraggingAtPoint!(pointOnSourceDraggable)
            
        case .Changed:
            var repImageFrame = bund.representationImageView.frame
            repImageFrame.origin = CGPointMake(pointOnCanvas.x - bund.offset.x, pointOnCanvas.y - bund.offset.y)
            bund.representationImageView.frame = repImageFrame
            
            var overlappingArea: CGFloat = 0
            var mainOverView: UIView?
            for view in views.filter({ (v) -> Bool in v is JDDraggable }) {
                let viewFrameOnCanvas = converRectToCanvas(view.frame, fromView: view)
                
                let intersectionNew = CGRectIntersection(bund.representationImageView.frame, viewFrameOnCanvas).size
                
                if (intersectionNew.width * intersectionNew.height) > overlappingArea {
                    overlappingArea = intersectionNew.width * intersectionNew.height
                    mainOverView = view
                }
            }// for
            
            guard let droppable = mainOverView as? JDDroppable else {
                break
            }
            
            let rect = canvas.convertRect(bund.representationImageView.frame, toView: mainOverView)
            
            if droppable.canDropAtRect(rect) {
                if mainOverView != bund.overDroppableView {
                    //if it is the first time we are entering
                    (bund.overDroppableView as! JDDroppable).didMoveOutItem(bund.dataItem)
                    droppable.willMoveItem(bund.dataItem, inRect: rect)
                }
                
                bundle?.overDroppableView = mainOverView
                droppable.didMoveItem(bund.dataItem, inRect: rect)
            }//if droppable
            
        case .Ended:
            
            if bund.sourceDraggableView != bund.overDroppableView {
                guard let droppable = bund.overDroppableView as? JDDroppable else {
                    break
                }
                
                sourceDraggable.dragDataItem(bund.dataItem)
                
                let rect = canvas.convertRect(bund.representationImageView.frame, toView: bund.overDroppableView)
                droppable.dropDataItem(bund.dataItem, atRect: rect)
            }
            
            bund.representationImageView.removeFromSuperview()
            sourceDraggable.stopDragging?()
            
        default:
            break
        }//switch
        
    }
    
    func converRectToCanvas(rect: CGRect, fromView view: UIView) -> CGRect {
        var r : CGRect = rect
        var v = view
        
        while v != canvas {
            guard let sv = v.superview else {
                break
            }
            
            r.origin.x += sv.frame.origin.x
            r.origin.y += sv.frame.origin.y
            
            v = sv
            continue
        }
        
        return r
    }
    
}
