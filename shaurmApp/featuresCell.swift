//
//  featuresCellTableViewCell.swift
//  shaurmApp
//
//  Created by Tim on 2015-11-06.
//  Copyright © 2015 Nikolaev Igor. All rights reserved.
//

import UIKit

class featuresCell: UITableViewCell {
    var delegate:StarViewDelegate? = nil

    class var height: CGFloat {get{return 80}}
    //var categories:[String] = ["Размер","Перчатки","Соус","Мастер"]
    var labelOne: UILabel!
    var labelTwo: UILabel!
    var labelText:[String] = []

    
    
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
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        delegate!.dismissStarView(self)
    }

}
