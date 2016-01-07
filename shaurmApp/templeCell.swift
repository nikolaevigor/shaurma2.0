//
//  templeCell.swift
//  shaurmApp
//
//  Created by Tim on 2015-08-28.
//  Copyright (c) 2015 Nikolaev Igor. All rights reserved.
//

import UIKit

class templeCell: UITableViewCell {

    
    @IBOutlet weak var templeImage: UIImageView!
    @IBOutlet weak var templeTitleLabel: UILabel!
    
    var templeId = String()
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.separatorInset = UIEdgeInsetsZero

        
        let width = UIScreen.mainScreen().bounds.width
        
        contentView.frame = CGRectMake(0, 0, width, 120)
        
        //profileImage.center = CGPointMake(60, 60)
        // profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        //templeImage.clipsToBounds =  true
        //profileNameLabel.center = CGPointMake(230, 55)
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


