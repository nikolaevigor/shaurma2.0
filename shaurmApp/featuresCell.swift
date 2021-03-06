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
    
    @IBOutlet weak var sizeImage: UIImageView!
    @IBOutlet weak var hotImage: UIImageView!
    @IBOutlet weak var glovesImage: UIImageView!
    
    class var height: CGFloat {get{return 80}}
    //var categories:[String] = ["Размер","Перчатки","Соус","Мастер"]
    var labelOne: UILabel!
    var labelTwo: UILabel!
    var labelText:[String] = []
    
    //
    //    func setLabelText(t1: String, t2: String){
    //        self.labelOne.text = t1
    //        self.labelOne.sizeToFit()
    //
    //        self.labelTwo.text = t2
    //        self.labelTwo.sizeToFit()
    //    }
    
    
    func setImages(size: String, hot: NSNumber, gloves: NSNumber){
        if size == "S"{
            self.sizeImage.image = UIImage(named: "S")
        }else if size == "M"{
            self.sizeImage.image = UIImage(named: "M")
        }else if size == "L"{
            self.sizeImage.image = UIImage(named: "L")
        }else if size == "XL"{
            self.sizeImage.image = UIImage(named: "XL")
        }else {
            self.sizeImage.image = UIImage(named: "emptyIcon")
        }
        
        
        if hot.isEqualToNumber(1) {
            self.hotImage.image  = UIImage(named: "pepper")
        }else if hot.isEqualToNumber(0) {
            self.hotImage.image  = UIImage(named: "no-chili")
        }
        else if gloves.isEqualToNumber(2){
            self.sizeImage.image = UIImage(named: "emptyIcon")
        }
        
        if gloves.isEqualToNumber(1) {
            self.glovesImage.image  = UIImage(named: "gloves")
            
        }else if gloves.isEqualToNumber(0) {
            self.glovesImage.image  = UIImage(named: "no-gloves")
        }
        else if gloves.isEqualToNumber(2){
            self.sizeImage.image = UIImage(named: "emptyIcon")
        }
    }
    
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        delegate!.dismissStarView(self)
    }
    
}
