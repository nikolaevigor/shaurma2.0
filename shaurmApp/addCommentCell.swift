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

    
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    class var expandedHeight: CGFloat {get{return 300}}
    class var defaultHeight: CGFloat {get{return 100}}
    
    var delegate:StarViewDelegate? = nil    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.whiteColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        let width = UIScreen.mainScreen().bounds.width
        let vertCenter = addCommentCell.defaultHeight/2
        
        commentTextView.frame.origin.y = vertCenter + commentTextView.frame.height/2
        commentTextView.autocorrectionType = UITextAutocorrectionType.No
        commentTextView.keyboardType = UIKeyboardType.Default
        commentTextView.returnKeyType = UIReturnKeyType.Done
        commentTextView.hidden = true
        
        submitButton.frame = CGRectMake(0, vertCenter + 1.5*commentTextView.frame.height + 20, 150, 30)
        submitButton.hidden = true
        submitButton.titleLabel?.textAlignment = NSTextAlignment.Center
        
        expandButton.titleLabel?.textAlignment = NSTextAlignment.Center
        
        submitButton.frame.origin.x = width/2 + 5
        submitButton.frame.origin.y = vertCenter - submitButton.frame.height/2
        submitButton.titleLabel?.textAlignment = NSTextAlignment.Center
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
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "frame" {
            checkHeight()
        }
    }
    
    func checkHeight(){
        if self.frame.size.height > addCommentCell.defaultHeight{
            UIView.animateWithDuration(0.1, animations: {
                self.commentTextView.alpha = 1.0
                self.submitButton.alpha = 1.0
                
            })
            self.commentTextView.hidden = false
            self.submitButton.hidden = false

        }
        else{
            UIView.animateWithDuration(0.1, animations: {
                self.commentTextView.alpha = 0.0
                self.submitButton.alpha = 0.0
                
            })
            self.commentTextView.hidden = true
            self.submitButton.hidden = true
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        delegate!.dismissStarView(self)
    }
    
    
    
}


