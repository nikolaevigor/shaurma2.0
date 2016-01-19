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
    class var expandedHeight: CGFloat {get{return 180}}
    class var defaultHeight: CGFloat {get{return 70}}

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.whiteColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        let width = UIScreen.mainScreen().bounds.width
        
        contentView.frame = CGRectMake(0, 0, width, 100)

        let vertCenter = menuCell.defaultHeight/2
    
        titleLabel = UILabel(frame: CGRectMake(0, vertCenter, 10, 10))
        titleLabel.text = "Меню"
        titleLabel.font = UIFont(name: "HelveticaNeue", size: 25.0)
        titleLabel.textColor = UIColor.blueColor()
        titleLabel.sizeToFit()
        titleLabel.center = self.center
        titleLabel.center.y = vertCenter
        
        let menuPic : UIImage = UIImage(named:"menu")!
        menuPicView = UIImageView(image: menuPic)
        menuPicView.frame = CGRect(x: 0, y: vertCenter - menuPicView.frame.height/2, width: 50, height: 50)
        
        
        titleLabel.center.x = self.center.x + (titleLabel.frame.width/2 + 20 + menuPicView.frame.width/2) / 2
        menuPicView.center.x = self.center.x - (titleLabel.frame.width/2 + 50 + menuPicView.frame.width/2) / 2
        
        rowOneLabel = UILabel(frame: CGRectMake(0, vertCenter, 300, 100))
        rowOneLabel.numberOfLines = 0
        rowOneLabel.text = "Шаурма в пите - 150р\nШаурма в лаваше - 120р"
        rowOneLabel.font = UIFont(name: "HelveticaNeue", size: 17.0)
        rowOneLabel.textColor = UIColor.darkGrayColor()
        rowOneLabel.sizeToFit()
        rowOneLabel.center = self.center
        rowOneLabel.center.y = menuCell.expandedHeight / 2
        rowOneLabel.textAlignment = .Left
        rowOneLabel.hidden = true
        


    

        contentView.addSubview(menuPicView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(rowOneLabel)


    }
    
    deinit{
        //print("DEINIT")
        self.ignoreFrameChanges()
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


}


