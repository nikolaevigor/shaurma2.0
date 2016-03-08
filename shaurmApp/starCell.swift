//
//  starCell.swift
//  shaurmApp
//
//  Created by Tim on 2015-09-10.
//  Copyright (c) 2015 Nikolaev Igor. All rights reserved.
//

import UIKit

class starCell: UITableViewCell {
    class var expandedHeight: CGFloat {get{return 100}}
    class var defaultHeight: CGFloat {get{return 100}}

    
    var action = false
    
    //@IBOutlet var starView: HCSStarRatingView!
    var totalLabel: UILabel!
    var recentLabel: UILabel!
    var markLabel: UILabel!

    var delegate:StarViewDelegate? = nil

    
    var starView = HCSStarRatingView()
    
    var value = CGFloat()

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //super.awakeFromNib()
        let width = UIScreen.mainScreen().bounds.width
        
        contentView.frame = CGRectMake(0, 0, width, starCell.defaultHeight)
        
        starView.value = self.value
        starView.frame = CGRect(x: 0,y: 0, width: width, height: 50)
        starView.addTarget(self, action: "changeValue:", forControlEvents: UIControlEvents.AllTouchEvents)
        
        
        self.separatorInset = UIEdgeInsetsZero
        self.layoutMargins = UIEdgeInsetsZero
        self.preservesSuperviewLayoutMargins = false
        
        
        totalLabel = UILabel(frame: CGRectMake(0, starCell.defaultHeight - 20.0, 10, 10))
        totalLabel.text = "Всего оценок: 123"
        totalLabel.font = UIFont(name: "HelveticaNeue", size: 18.0)
        totalLabel.textColor = UIColor.blackColor()
        totalLabel.sizeToFit()
        
        recentLabel = UILabel(frame: CGRectMake(width/2 + 5, starCell.defaultHeight - 20.0, 10, 10))
        recentLabel.text = "Моя оценка: -"
        recentLabel.font = UIFont(name: "HelveticaNeue", size: 18.0)
        recentLabel.textColor = UIColor.blackColor()
        recentLabel.sizeToFit()
        
        markLabel = UILabel(frame: CGRectMake(0, starCell.defaultHeight - 50, width, 50))
        markLabel.text = "ОЦЕНИТЬ"
        markLabel.font = UIFont(name: "HelveticaNeue", size: 18.0)
        markLabel.textColor = UIColor.blackColor()
        markLabel.textAlignment = NSTextAlignment.Center
        markLabel.backgroundColor = UIColor.whiteColor()
        markLabel.hidden = true
        markLabel.alpha = 0.0
        
        
        
        contentView.addSubview(totalLabel)
        contentView.addSubview(recentLabel)
        contentView.addSubview(markLabel)
        contentView.addSubview(starView)



    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @IBAction func valueChanged(sender: AnyObject) {        
        UIView.animateWithDuration(0.5, animations: {
            self.totalLabel.hidden = true
            self.recentLabel.hidden = true
            self.markLabel.hidden = false
            self.markLabel.alpha = 1.0
            
        })
    }
    
    
    @IBAction func changeValue(sender: HCSStarRatingView){
        UIView.animateWithDuration(0.5, animations: {
            self.totalLabel.hidden = true
            self.recentLabel.hidden = true
            self.markLabel.hidden = false
            self.markLabel.alpha = 1.0
            self.value = self.starView.value
            
        })
    
    }
    
    func expandHeight(){
    
        UIView.animateWithDuration(0.5, animations: {
        self.frame.size.height = 100
        })
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        delegate!.dismissStarView(self)
    }
    


    
}

