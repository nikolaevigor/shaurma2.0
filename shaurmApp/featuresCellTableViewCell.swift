//
//  featuresCellTableViewCell.swift
//  shaurmApp
//
//  Created by Tim on 2015-11-06.
//  Copyright © 2015 Nikolaev Igor. All rights reserved.
//

import UIKit

class featuresCell: UITableViewCell {
    class var height: CGFloat {get{return 80}}
    //var categories:[String] = ["Размер","Перчатки","Соус","Мастер"]
    var labelOne: UILabel!
    var labelTwo: UILabel!
    var labelText:[String] = []




    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.userInteractionEnabled = false
        
        let width = UIScreen.mainScreen().bounds.width
        self.contentView.frame = CGRectMake(0, 0, width, featuresCell.height)
        self.frame = CGRectMake(0, 0, width, featuresCell.height)

    
        //SEPARATOR
        let separatorView = UIView()
        separatorView.frame = CGRectMake(width/2, 0, 0.7, featuresCell.height)
        separatorView.backgroundColor = UIColor.lightGrayColor()
        
        contentView.addSubview(separatorView)
        
        
        // LABEL VIEWS
        
        labelOne = UILabel(frame: CGRectMake(5, contentView.frame.height*1/2, 10, 10))
        labelOne.font = UIFont(name: "HelveticaNeue", size: 15.0)
        labelOne.textColor = UIColor.blackColor()
        labelOne.sizeToFit()
        
        labelTwo = UILabel(frame: CGRectMake(width/2 + 5, contentView.frame.height*1/2, 10, 10))
        labelTwo.font = UIFont(name: "HelveticaNeue", size: 15.0)
        labelTwo.textColor = UIColor.blackColor()
        labelTwo.sizeToFit()
        
        
        
        //labelOne.center.y = contentView.frame.height*3/4
        //labelOne.center.x = 0
        
        contentView.addSubview(labelOne)
        contentView.addSubview(labelTwo)




        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setLabelText(t1: String, t2: String){
        self.labelOne.text = t1
        self.labelOne.sizeToFit()
        
        self.labelTwo.text = t2
        self.labelTwo.sizeToFit()
    }
    


    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
