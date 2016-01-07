

//
//  draggableTableView.swift
//  shaurmApp
//
//  Created by Tim on 2015-08-28.
//  Copyright (c) 2015 Nikolaev Igor. All rights reserved.
//

import UIKit

class draggableTableView: UITableView {

    var dragStartPositionRelativeToCenter : CGPoint?
    var minY = CGFloat()
    
    override func awakeFromNib() {
    
        super.awakeFromNib()
        
    
        self.userInteractionEnabled = true   
        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "handlePan:"))
        
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 2
        
        
        minY = self.center.y
    }
    
    

  
    
    func handlePan(nizer: UIPanGestureRecognizer!) {
        if nizer.state == UIGestureRecognizerState.Began {
            
            
            let locationInView = nizer.locationInView(superview)
            dragStartPositionRelativeToCenter = CGPoint(x: 0, y: locationInView.y - center.y)
            
            layer.shadowOffset = CGSize(width: 0, height: 20)
            layer.shadowOpacity = 0.3
            layer.shadowRadius = 6
            
            
            return
        }
        
        if nizer.state == UIGestureRecognizerState.Ended {
            dragStartPositionRelativeToCenter = nil
            
            layer.shadowOffset = CGSize(width: 0, height: 3)
            layer.shadowOpacity = 0.5
            layer.shadowRadius = 2
            
            return
        }
        
        let locationInView = nizer.locationInView(superview)
        
        var y = locationInView.y - self.dragStartPositionRelativeToCenter!.y
        
        if y > minY {
                y = minY
        }
        
        UIView.animateWithDuration(0.1) {
            self.center = CGPoint(x: self.center.x,
                y: y)
        }
    }

}
