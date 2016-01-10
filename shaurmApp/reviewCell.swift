//
//  resultsCell.swift
//  messenger
//
//  Created by Tim on 2015-08-25.
//  Copyright (c) 2015 Tim corp. All rights reserved.
//

import UIKit

class reviewCell: UITableViewCell {

    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var categoryTitleLabel: UILabel!
    
    var titleLbl = UILabel(frame: CGRectMake(0, 0, 20, 10))
    var categoryId = String()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
        let width = UIScreen.mainScreen().bounds.width
        
        contentView.frame = CGRectMake(0, 0, width, 120)
        categoryImage.clipsToBounds =  true
        titleLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 21)
        
    }
    
    


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
