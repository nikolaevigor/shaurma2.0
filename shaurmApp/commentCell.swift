//
//  commentCell.swift
//  shaurmApp
//
//  Created by Tim on 2015-09-02.
//  Copyright (c) 2015 Nikolaev Igor. All rights reserved.
//

import UIKit

class commentCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentTextLabel: UILabel!
    
    @IBOutlet weak var headerLabel: UILabel!
    var delegate:StarViewDelegate? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        //super.init(style: style, reuseIdentifier: reuseIdentifier)
        //selectionStyle = .None
        
        let width = UIScreen.mainScreen().bounds.width
        
        contentView.frame = CGRectMake(0, 0, width, 120)
        
        self.separatorInset = UIEdgeInsetsZero
        self.layoutMargins = UIEdgeInsetsZero
        self.preservesSuperviewLayoutMargins = false


        commentTextLabel.sizeToFit()
        commentTextLabel.numberOfLines = 0
        dateLabel.sizeToFit()
        userNameLabel.sizeToFit()
        

    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        delegate!.dismissStarView(self)
    }
    
    func hideHeader(){
        self.headerLabel.text = ""
        //self.headerLabel.hidden = true
    }

    
    
}
