//
//  addCommentCell.swift
//  shaurmApp
//
//  Created by Tim on 2015-11-16.
//  Copyright © 2015 Nikolaev Igor. All rights reserved.
//

import UIKit

class addCommentCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var seeAllButton: UIButton!
    @IBOutlet weak var expandButton: UIButton!

    
    
    class var expandedHeight: CGFloat {get{return 300}}
    class var defaultHeight: CGFloat {get{return 89}}
    
    var delegate:StarViewDelegate? = nil    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.whiteColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None

        
        expandButton.titleLabel?.textAlignment = NSTextAlignment.Center

    }
    
    deinit{
        self.ignoreFrameChanges()
    }
    

    
    
    func watchFrameChanges(){
        if self.observationInfo == nil {
            self.addObserver(self, forKeyPath: "frame", options: .New, context: nil)
        }
    }
    
    
    func ignoreFrameChanges(){
        if self.observationInfo != nil {
            self.removeObserver(self, forKeyPath: "frame")
        }
    }
    

    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        delegate!.dismissStarView(self)
    }
    
    
    
}


