//
//  menuCell.swift
//  shaurmApp
//
//  Created by Tim on 2015-09-10.
//  Copyright (c) 2015 Nikolaev Igor. All rights reserved.
//

import UIKit



class menuCell: UITableViewCell {
    var titleLabel: UILabel!
    var rowOneLabel: UILabel!
    var menuPicView: UIImageView!
    var menuData: NSArray!
    class var expandedHeight: CGFloat {get{return 150}}
    class var defaultHeight: CGFloat {get{return 65}}
    var delegate:StarViewDelegate? = nil
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        //self.backgroundColor = UIColor(red: CGFloat(228.0/255.0), green: CGFloat(242.0/255.0), blue: CGFloat(254.0/255.0), alpha: 1.0)
        
        //self.backgroundColor = UIColor(red: CGFloat(103.0/255.0), green: CGFloat(128.0/255.0), blue: CGFloat(159.0/255.0), alpha: 1.0)

        self.backgroundColor = UIColor(red: CGFloat(236.0/255.0), green: CGFloat(236.0/255.0), blue: CGFloat(236.0/255.0), alpha: 1.0)

        
        
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        let width = UIScreen.mainScreen().bounds.width
        
        contentView.frame = CGRectMake(0, 0, width, 100)

        let vertCenter = menuCell.defaultHeight/2
    
        titleLabel = UILabel(frame: CGRectMake(0, vertCenter, 10, 10))
        titleLabel.text = "Меню"
        titleLabel.font = UIFont(name: "Montserrat-Light", size: 25.0)
        //titleLabel.textColor = UIColor(red: 34.0 , green: 49.0, blue: 63.0, alpha: 1.0)
        //titleLabel.textColor = UIColor(red: 197.0, green: 239.0, blue: 247.0, alpha: 1.0)

        
        titleLabel.textColor = UIColor.blackColor()
        
        titleLabel.sizeToFit()
        titleLabel.center = self.center
        titleLabel.center.y = vertCenter
        
        let menuPic : UIImage = UIImage(named:"menu")!
        menuPicView = UIImageView(image: menuPic)
        //menuPicView.frame = CGRect(x: 0, y: vertCenter - menuPicView.frame.height/2, width: 50, height: 50)
        
        
        //titleLabel.center.x = self.center.x + (titleLabel.frame.width/2 + 20 + menuPicView.frame.width/2) / 2
        //menuPicView.center.x = self.center.x - (titleLabel.frame.width/2 + 50 + menuPicView.frame.width/2) / 2
        
        titleLabel.center.x = self.center.x

        
        rowOneLabel = UILabel(frame: CGRectMake(0, vertCenter, 300, 100))
        rowOneLabel.numberOfLines = 0
        
        
        self.refresh()
        rowOneLabel.font = UIFont(name: "HelveticaNeue", size: 17.0)
        rowOneLabel.textColor = UIColor.darkGrayColor()

        rowOneLabel.textAlignment = .Left
        rowOneLabel.hidden = true
        


    

        //contentView.addSubview(menuPicView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(rowOneLabel)


    }
    
    deinit{
        //print("DEINIT")
        self.ignoreFrameChanges()
    }
    
    func refresh(){
        var rowText = ""
        
        if let menuData = self.menuData {
            for a in menuData {
                rowText.appendContentsOf("Шаурма \((a as! NSArray)[0]) - \((a as! NSArray)[1])\n")
            }
            
        }
        rowOneLabel.text = rowText
        rowOneLabel.sizeToFit()
        rowOneLabel.center = self.center
        rowOneLabel.center.y = menuCell.expandedHeight / 2


    }

    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func watchFrameChanges(){
        if self.observationInfo == nil {
            self.addObserver(self, forKeyPath: "frame", options: .New, context: nil)
            //print("WATCH")
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.setSelected(true, animated: false)
        super.touchesBegan(touches, withEvent: event)
        delegate!.dismissStarView(self)
    }


}


