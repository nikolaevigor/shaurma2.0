//
//  menuCell.swift
//  shaurmApp
//
//  Created by Tim on 2015-09-10.
//  Copyright (c) 2015 Nikolaev Igor. All rights reserved.
//

import UIKit


//  Данные для меню хранятся в таком виде
//  [["в обычном лаваше",150],["в сырном лаваше",180],["в пите",190]]

class menuCell: UITableViewCell {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var rowOneLabel: UILabel!
    var menuData: NSArray!
    class var defaultHeight: CGFloat {get{return 65}}
    var delegate:StarViewDelegate? = nil
    
    override func awakeFromNib() {
        rowOneLabel.hidden = true
        self.refresh()
    }

    
    func refresh(){
        var rowText = ""
        
        if let menuData = self.menuData {
            for a in menuData {
                rowText.appendContentsOf("Шаурма \((a as! NSArray)[0]) - \((a as! NSArray)[1])₽\n")
            }
            
        }
        rowOneLabel.text = rowText
        rowOneLabel.sizeToFit()
    }


    
    func watchFrameChanges(){
        if self.observationInfo == nil {
            self.addObserver(self, forKeyPath: "frame", options: .New, context: nil)
        }

        //checkHeight()
    }
    
    
    func ignoreFrameChanges(){
        if self.observationInfo != nil {
        self.removeObserver(self, forKeyPath: "frame")
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "frame" {
            checkHeight()
        }
    }
    
    

    
    
    func checkHeight(){
        if self.frame.size.height > menuCell.defaultHeight{
        UIView.animateWithDuration(0.1, animations: {
            self.rowOneLabel.alpha = 1.0
        })
            self.rowOneLabel.hidden = false

        }
        else{
            UIView.animateWithDuration(0.1, animations: {
                self.rowOneLabel.alpha = 0.0
            })
            self.rowOneLabel.hidden = true

        }
    
    }

    
    func getCellHeight() -> CGFloat{
        return(self.rowOneLabel.frame.height + 108)
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.setSelected(true, animated: false)
        super.touchesBegan(touches, withEvent: event)
        delegate!.dismissStarView(self)
    }
    

    

    



}


