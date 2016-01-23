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
    
    //var seeAllButton: UIButton!
    //var expandButton: UIButton!
    //var addButton: UIButton!
    //var submitButton: UIButton!
    //var commentField: UITextView!
    
    class var expandedHeight: CGFloat {get{return 300}}
    class var defaultHeight: CGFloat {get{return 100}}
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.whiteColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        let width = UIScreen.mainScreen().bounds.width
        
       // contentView.frame = CGRectMake(0, 0, width, addCommentCell.defaultHeight)
        let vertCenter = addCommentCell.defaultHeight/2
        
        
        //commentTextView = UITextView(frame: CGRectMake(0, 0, 300, 100))
        //commentTextView = UITextField(frame: CGRectMake(0, 0, 300, 100))
        //commentTextView = self.center
        //commentTextView.textColor = UIColor.blackColor()
        //commentField.placeholder = "Введите текст"
        //commentTextView.backgroundColor = UIColor.lightGrayColor()
        //commentTextView.font = UIFont(name: "HelveticaNeue", size: 15.0)
        //commentField.clearButtonMode = UITextFieldViewMode.WhileEditing;
        //commentTextView.delegate = self
        
        
        commentTextView.frame.origin.y = vertCenter + commentTextView.frame.height/2
        commentTextView.autocorrectionType = UITextAutocorrectionType.No
        commentTextView.keyboardType = UIKeyboardType.Default
        commentTextView.returnKeyType = UIReturnKeyType.Done
        commentTextView.hidden = true
        
        
        //submitButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20.0)!
        //submitButton.setTitle("Добавить", forState: UIControlState.Normal)
        //submitButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 18.0)!
        //submitButton.titleLabel?.textColor = UIColor.whiteColor()
        //submitButton.backgroundColor = UIColor.blueColor()
        //submitButton = UIButton(frame: CGRectMake(0, vertCenter + 1.5*commentTextView.frame.height + 20, 150, 30))
        
        submitButton.frame = CGRectMake(0, vertCenter + 1.5*commentTextView.frame.height + 20, 150, 30)
        submitButton.hidden = true
        submitButton.titleLabel?.textAlignment = NSTextAlignment.Center
        
        print(width)
        
        expandButton.frame = CGRectMake(0, 0, width/2 - 10, (width/2 - 10)/2.5)
        expandButton.frame.origin.x = width/2 - expandButton.frame.width - 5
        expandButton.frame.origin.y = vertCenter - expandButton.frame.height/2

        //expandButton.setTitle("Все отзывы", forState: UIControlState.Normal)
        //expandButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 18.0)!
        //expandButton.titleLabel?.textColor = UIColor.blackColor()
        //expandButton.backgroundColor = UIColor.grayColor()
        expandButton.titleLabel?.textAlignment = NSTextAlignment.Center
        
        
        seeAllButton.frame.origin.x = width/2 + seeAllButton.frame.width + 5

        //submitButton = UIButton(frame: CGRectMake(0, 0, width/2 - 10, (width/2 - 10)/2.5))
        submitButton.frame.origin.x = width/2 + 5
        submitButton.frame.origin.y = vertCenter - submitButton.frame.height/2
        
        //submitButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20.0)!
        //submitButton.setTitle("Написать отзыв", forState: UIControlState.Normal)
        //submitButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 18.0)!
        //submitButton.titleLabel?.textColor = UIColor.blackColor()
        //submitButton.backgroundColor = UIColor.grayColor()
        
        submitButton.titleLabel?.textAlignment = NSTextAlignment.Center
        

        //submitButton.frame.width

        
        
//        
//        
          //contentView.addSubview(commentTextView)
//        contentView.addSubview(expandButton)
//        //contentView.addSubview(addButton)
//        contentView.addSubview(submitButton)
//
//        
    }
    
    deinit{
        self.ignoreFrameChanges()
    }
    

    
    
    func watchFrameChanges(){
        if self.observationInfo == nil {
            self.addObserver(self, forKeyPath: "frame", options: .New, context: nil)
        }
        
        //checkHeight()
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
    
    
    
}


