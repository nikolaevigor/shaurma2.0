//
//  commentCell.swift
//  shaurmApp
//
//  Created by Tim on 2015-09-02.
//  Copyright (c) 2015 Nikolaev Igor. All rights reserved.
//

import UIKit

class commentCell: UITableViewCell {

    var commentTextLabel: UILabel!
    var dateLabel: UILabel!
    var userNameLabel: UILabel!
    
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //selectionStyle = .None
        
        let width = UIScreen.mainScreen().bounds.width
        
        contentView.frame = CGRectMake(0, 0, width, 120)
        
        self.separatorInset = UIEdgeInsetsZero
        self.layoutMargins = UIEdgeInsetsZero
        self.preservesSuperviewLayoutMargins = false



        
        let commentWidth = width - 80
        commentTextLabel = UILabel(frame: CGRectMake(20, 30, commentWidth, 50))
        commentTextLabel.numberOfLines = 0

        dateLabel = UILabel(frame: CGRectMake(150, 0, 20, 10))
        dateLabel.textColor = UIColor.lightGrayColor()
        dateLabel.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)

        
        userNameLabel = UILabel(frame: CGRectMake(50, 0, 20, 10))
        userNameLabel.textColor = UIColor.darkGrayColor()
        userNameLabel.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        

        
        contentView.addSubview(commentTextLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(userNameLabel)

        
        
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
