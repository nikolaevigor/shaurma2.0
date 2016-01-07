//
//  resultsCell.swift
//  messenger
//
//  Created by Tim on 2015-08-25.
//  Copyright (c) 2015 Tim corp. All rights reserved.
//

import UIKit

class categoryCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let width = UIScreen.mainScreen().bounds.width
        
        contentView.frame = CGRectMake(0, 0, width, 120)
        
        profileImage.center = CGPointMake(60, 60)
        profileImage.layer.cornerRadius = profileImage.frame.size.width/2
        profileImage.clipsToBounds =  true
        profileNameLabel.center = CGPointMake(230, 55)
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
