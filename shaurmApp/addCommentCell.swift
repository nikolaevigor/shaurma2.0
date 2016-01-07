//
//  addCommentCell.swift
//  shaurmApp
//
//  Created by Tim on 2015-11-16.
//  Copyright © 2015 Nikolaev Igor. All rights reserved.
//

import UIKit

class addCommentCell: UITableViewCell, UITextFieldDelegate {
    var seeAllButton: UIButton!
    var expandButton: UIButton!
    var addButton: UIButton!


    
    var submitButton: UIButton!
    var commentField: UITextField!
    
    class var expandedHeight: CGFloat {get{return 300}}
    class var defaultHeight: CGFloat {get{return 100}}
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        print("ADD INIT")
        
        
        self.backgroundColor = UIColor.whiteColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        let width = UIScreen.mainScreen().bounds.width
        
        contentView.frame = CGRectMake(0, 0, width, 100)
        let vertCenter = addCommentCell.defaultHeight/2
        
        
        commentField = UITextField(frame: CGRectMake(0, 0, 300, 100))
        commentField.frame.origin.y = vertCenter + commentField.frame.height/2
        commentField.font = UIFont(name: "HelveticaNeue", size: 15.0)
        commentField.textColor = UIColor.blackColor()
        //commentField.center = self.center
        commentField.backgroundColor = UIColor.lightGrayColor()
        commentField.delegate = self
        
        commentField.placeholder = "Введите текст"
        commentField.autocorrectionType = UITextAutocorrectionType.No
        commentField.keyboardType = UIKeyboardType.Default
        commentField.returnKeyType = UIReturnKeyType.Done
        commentField.clearButtonMode = UITextFieldViewMode.WhileEditing;
        commentField.hidden = true
        
        submitButton = UIButton(frame: CGRectMake(0, vertCenter + 1.5*commentField.frame.height + 20, 150, 30))
        submitButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20.0)!
        submitButton.setTitle("Добавить", forState: UIControlState.Normal)
        submitButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 18.0)!
        submitButton.titleLabel?.textColor = UIColor.whiteColor()
        submitButton.backgroundColor = UIColor.blueColor()
        submitButton.hidden = true
        submitButton.titleLabel?.textAlignment = NSTextAlignment.Center
        

        print(width)
        
        expandButton = UIButton(frame: CGRectMake(0, 0, width/2 - 10, (width/2 - 10)/2.5))
        expandButton.frame.origin.x = width/2 - expandButton.frame.width - 5
        expandButton.frame.origin.y = vertCenter - expandButton.frame.height/2

        expandButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20.0)!
        expandButton.setTitle("Все отзывы", forState: UIControlState.Normal)
        expandButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 18.0)!
        expandButton.titleLabel?.textColor = UIColor.blackColor()
        expandButton.backgroundColor = UIColor.grayColor()
        expandButton.titleLabel?.textAlignment = NSTextAlignment.Center
        
        addButton = UIButton(frame: CGRectMake(0, 0, width/2 - 10, (width/2 - 10)/2.5))
        addButton.frame.origin.x = width/2 + 5
        addButton.frame.origin.y = vertCenter - addButton.frame.height/2
        addButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 20.0)!
        addButton.setTitle("Написать отзыв", forState: UIControlState.Normal)
        addButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 18.0)!
        addButton.titleLabel?.textColor = UIColor.blackColor()
        addButton.backgroundColor = UIColor.grayColor()
        addButton.titleLabel?.textAlignment = NSTextAlignment.Center
        

        addButton.frame.width

        
        
        
        
        contentView.addSubview(commentField)
        contentView.addSubview(expandButton)
        contentView.addSubview(addButton)
        contentView.addSubview(submitButton)

        
    }
    
    deinit{
        //print("DEINIT")
        self.ignoreFrameChanges()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func watchFrameChanges(){
        if self.observationInfo == nil {
            self.addObserver(self, forKeyPath: "frame", options: .New, context: nil)
            print("WATCH")
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
                self.commentField.alpha = 1.0
                self.submitButton.alpha = 1.0
                
            })
            self.commentField.hidden = false
            self.submitButton.hidden = false

        }
        else{
            UIView.animateWithDuration(0.1, animations: {
                self.commentField.alpha = 0.0
                self.submitButton.alpha = 0.0
                

            })
            self.commentField.hidden = true
            self.submitButton.hidden = true
        }
        
    }
    
    
    
}


