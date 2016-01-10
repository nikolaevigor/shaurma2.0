//
//  newTempleVC.swift
//  shaurmApp
//
//  Created by Tim on 2015-09-10.
//  Copyright (c) 2015 Nikolaev Igor. All rights reserved.
//

import UIKit

class newTempleVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    let tableHeaderHeight: CGFloat = 250.0
    var activeCellIndexPath = 0
    
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var starView: HCSStarRatingView!
    @IBOutlet weak var recentLabel: UILabel!
    @IBOutlet weak var markButton: UIButton!
    
    @IBAction func markButtonPressed(sender: AnyObject) {
        print(starView.value)
        UIView.animateWithDuration(0.5, animations: {
                self.totalLabel.hidden = false
                self.recentLabel.hidden = false
                self.markButton.hidden = true
                self.markButton.alpha = 0.0
                
            })
            
    }
    
    @IBAction func changeValue(sender: AnyObject) {
        print(starView.value)
        UIView.animateWithDuration(0.5, animations: {
            self.totalLabel.hidden = true
            self.recentLabel.hidden = true
            self.markButton.hidden = false
            self.markButton.alpha = 1.0
            self.templeRating = self.starView.value
            
        })
    }
    

    @IBOutlet weak var mainTableView: UITableView!
    let width = UIScreen.mainScreen().bounds.width
    var headerView: UIView!
    var starWidgetView: UIView!
    
    var id = String()
    var templeTitle = String()
    var templeRating = CGFloat()
    var commentText = String()
    
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var templePictureView: UIImageView!
    @IBOutlet weak var templeTitleLabel: UILabel!
    @IBOutlet weak var subwayLabel: UILabel!
    
    //var subwayLabel: UILabel!

    var selectedIndexPath:NSIndexPath?
    var resultReviewArray = []

    
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        self.automaticallyAdjustsScrollViewInsets = false;
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)

        
        
        mainTableView.frame.size = UIScreen.mainScreen().bounds.size
        
        
       
        
        mainTableView.registerClass(menuCell.self, forCellReuseIdentifier: "menuCell")
        mainTableView.registerClass(featuresCell.self, forCellReuseIdentifier: "featuresCell")
        mainTableView.registerClass(commentCell.self, forCellReuseIdentifier: "commentCell")
        mainTableView.registerClass(addCommentCell.self, forCellReuseIdentifier: "addCommentCell")

        
        
        mainTableView.separatorInset = UIEdgeInsetsZero
        mainTableView.layoutMargins = UIEdgeInsetsZero
        mainTableView.preservesSuperviewLayoutMargins = false
        mainTableView.separatorStyle = .None
        
        




        totalLabel.text = "Всего оценок: 123"
        totalLabel.font = UIFont(name: "HelveticaNeue", size: 18.0)
        totalLabel.textColor = UIColor.blackColor()
        totalLabel.sizeToFit()
        
        recentLabel.text = "Моя оценка: 3"
        recentLabel.font = UIFont(name: "HelveticaNeue", size: 18.0)
        recentLabel.textColor = UIColor.blackColor()
        recentLabel.sizeToFit()
        
        

        markButton.setTitle("ОЦЕНИТЬ", forState: UIControlState.Normal)
        markButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 18.0)!
        markButton.titleLabel?.textAlignment = NSTextAlignment.Center
        markButton.alpha = 0.0
        markButton.hidden = true


        self.templeTitleLabel.numberOfLines = 0
        self.templeTitleLabel.center.x = self.view.center.x
        
        self.view.frame.size.width = width
        
        
        
        
        
        self.templeTitleLabel.alpha = 0.0
        self.subwayLabel.alpha = 0.0
        self.templePictureView.alpha = 0.0
        
        self.refresh()
        
        headerView = mainTableView.tableHeaderView
        mainTableView.tableHeaderView = nil
        mainTableView.addSubview(headerView)
        
        //headerView.addSubview(catTitleLabel)
        mainTableView.contentInset = UIEdgeInsets(top: tableHeaderHeight, left: 0, bottom: 0, right: 0)
        mainTableView.contentOffset = CGPoint(x: 0, y: -tableHeaderHeight)

    }

    
    func refresh() {
        
        let spinner = ShawarmaSpinnerView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(spinner)
        spinner.center.x = self.view.center.x
        spinner.center.y = self.view.center.y + 100.0
        
        spinner.start()
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage.init()
        self.navigationController?.view.backgroundColor = UIColor.clearColor()
        
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        

        
        PFQuery(className: "Temples2").getObjectInBackgroundWithId(id) {
            (object: AnyObject?, error: NSError?) -> Void in
            
            if (object != nil) {
                self.subwayLabel.text = object!.valueForKey("subway") as? String
                self.templeTitleLabel.text = object!.valueForKey("title") as? String
                self.templeTitleLabel.sizeToFit()
                self.subwayLabel.sizeToFit()
                
                if let obj = object!.valueForKey("image") {
                    
                    obj.getDataInBackgroundWithBlock {
                    (imageData:NSData?, error: NSError?) -> Void in
                    
                    if error == nil {
                        let image = UIImage(data: imageData!)
                        self.templePictureView.image = image
                        }
                    }
                }
            
            
            PFQuery(className: "Review").whereKey("temple", equalTo: object!).findObjectsInBackgroundWithBlock({ ( objects:[PFObject]?, error:NSError?) -> Void in
                if let objects = objects{
                self.resultReviewArray = objects
                }
            })


            }

            
            
//            do{
//                let comments = try PFQuery(className: "Review").whereKey("temple", equalTo: object!).findObjects()
//                self.resultReviewArray = comments
//            } catch let error as NSError {
//                print("Error: \(error.localizedDescription)")
//                abort()
//            }
            
            
            
    dispatch_async(dispatch_get_main_queue()) {
            self.mainTableView.reloadData()
        }
            
            spinner.hidden = true
            UIView.animateWithDuration(0.5, animations: {
                self.templeTitleLabel.alpha = 1.0
                self.mainTableView.alpha = 1.0
                self.subwayLabel.alpha = 1.0
                self.templePictureView.alpha = 1.0
            })
            spinner.stop()
        }

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0{
            if indexPath == selectedIndexPath{
                return menuCell.expandedHeight
            }
            else{
                return menuCell.defaultHeight
                }
        }
        if indexPath.row == 1 || indexPath.row == 2{
            return featuresCell.height
        }
        
        if indexPath.row >= 3 && indexPath.row <= 5 {
            if resultReviewArray.count < (indexPath.row - 2) {
                    return 0
                    }
                 }

        if indexPath.row == 6{
            if self.activeCellIndexPath == indexPath.row {
                return addCommentCell.expandedHeight
            }
            else{
                return addCommentCell.defaultHeight
            }
        }
        
        if indexPath.row == 7{
            if indexPath == selectedIndexPath{
                return addCommentCell.expandedHeight
            }
            else{
                return 0
            }
        }
        return 100
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        var categories:[String] = ["Размер","Перчатки","Соус","Мастер"]

        
        //SEPARATOR
        let separatorView = UIView()
        separatorView.frame = CGRectMake(0, 0, width, 0.7)
        separatorView.backgroundColor = UIColor.lightGrayColor()
        

        
        if indexPath.row == 0{
            let ccell:menuCell = tableView.dequeueReusableCellWithIdentifier("menuCell") as! menuCell
            cell = ccell
        }
        
        if indexPath.row == 1{
            
            let cccell:featuresCell = tableView.dequeueReusableCellWithIdentifier("featuresCell") as! featuresCell
            cccell.setLabelText(categories[0], t2: categories[1])
            cccell.frame.size.width = width
            cccell.clipsToBounds = true
            cell = cccell
            
        }
        
        if indexPath.row == 2{
            
            let cccell:featuresCell = tableView.dequeueReusableCellWithIdentifier("featuresCell") as! featuresCell
            cccell.setLabelText(categories[2], t2: categories[3])
            cccell.frame.size.width = width
            cccell.clipsToBounds = true
            cell = cccell
            
        }
        
        
        if indexPath.row >= 3 && indexPath.row <= 5 {
            let cccell:commentCell = tableView.dequeueReusableCellWithIdentifier("commentCell") as! commentCell
            cccell.sizeToFit()
            
            
            if resultReviewArray.count != 0 {
                if(indexPath.row - 3 < self.resultReviewArray.count){

                let commentDate:NSDate! = self.resultReviewArray[indexPath.row - 3].valueForKey("createdAt") as? NSDate
                let dateForm = NSDateFormatter()
                dateForm.dateStyle = NSDateFormatterStyle.LongStyle
                
                let commentDateStr = dateForm.stringFromDate(commentDate)
                
                
                
                cccell.dateLabel.text = commentDateStr
                cccell.commentTextLabel.text = self.resultReviewArray[indexPath.row - 3].valueForKey("comment") as? String
                    
                cccell.userNameLabel.text = self.resultReviewArray[indexPath.row - 3].valueForKey("userName") as? String
                
                cccell.commentTextLabel.sizeToFit()
                cccell.dateLabel.sizeToFit()
                cccell.userNameLabel.sizeToFit()
                    

                    
                }
                
            }
            cell = cccell
        }
        if indexPath.row == 6{
                let ccell:addCommentCell = tableView.dequeueReusableCellWithIdentifier("addCommentCell") as! addCommentCell
                ccell.submitButton.addTarget(self, action: "addCommentAction", forControlEvents: UIControlEvents.TouchUpInside)
                ccell.expandButton.addTarget(self, action: "expandButtonAction", forControlEvents: UIControlEvents.TouchUpInside)
                ccell.addButton.addTarget(self, action: "addButtonAction", forControlEvents: UIControlEvents.TouchUpInside)


                ccell.commentField.delegate = self
                cell = ccell
            
            }
        
        
        cell.addSubview(separatorView)
        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath{
        selectedIndexPath = nil
        }
        else{
            selectedIndexPath = indexPath
        }
        
        var indexPaths: Array<NSIndexPath> = []
        if let previous = previousIndexPath{
            indexPaths += [previous]
        }
        if let current = selectedIndexPath{
            indexPaths += [current]
        }
        
        if indexPaths.count > 0 {
            mainTableView.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.None)
        }
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
        if indexPath.row == 0{
        (cell as! menuCell).watchFrameChanges()
        }
        if indexPath.row == 6{
            (cell as! addCommentCell).watchFrameChanges()
        }
    
    }
    

    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0{
            (cell as! menuCell).ignoreFrameChanges()
        }
        if indexPath.row == 6{
            (cell as! addCommentCell).ignoreFrameChanges()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    func textFieldDidEndEditing(textField: UITextField) {
        self.commentText = textField.text!
    }
    
    

    func updateHeaderView(){
        var headerRect = CGRect(x: 0, y: -tableHeaderHeight, width: mainTableView.bounds.width, height: tableHeaderHeight)
        if mainTableView.contentOffset.y < -tableHeaderHeight {
            headerRect.origin.y = mainTableView.contentOffset.y
            headerRect.size.height = -mainTableView.contentOffset.y
        }
        
        headerView.frame = headerRect
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    func addCommentAction(){
        let text = self.commentText
        //print(text)

        if text != "" {
        let review = PFObject(className:"Review")
        review["comment"] = text
        review["userName"] = "Петя"
        
            PFQuery(className: "Temples2").getObjectInBackgroundWithId(self.id){
                (object: PFObject?, error: NSError?) -> Void in
                if let object = object {
                review["temple"] = object
                }
                }
                
        


        
        review.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                print("comment saved")
            } else {
                print(error)
            }
        }

    
            self.refresh()

            self.addButtonAction()


        }}
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "templeToComments") {
            
            let viewController:commentsVC = segue.destinationViewController as! commentsVC
            
            viewController.id = self.id
            viewController.templeTitle = self.templeTitle
        }
    }

    
    func addButtonAction(){

        if self.activeCellIndexPath == 6 {
            
            
            self.activeCellIndexPath = 0
            self.mainTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 6, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
        
            self.mainTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 6, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)

        }
        else{
            
            
            
            self.activeCellIndexPath = 6
            self.mainTableView.beginUpdates()
            self.mainTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 6, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Fade)
            self.mainTableView.endUpdates()
            
            
            self.mainTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 6, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
        
    }
    
    
    func expandButtonAction(){

        self.performSegueWithIdentifier("templeToComments", sender: self)

    
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        self.mainTableView.reloadData()

        self.mainTableView.scrollToRowAtIndexPath(NSIndexPath(index: 3), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)

        
        

        return true
    }
    
    func keyboardWillShow(notification: NSNotification) {
        //print("one")
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y -= (keyboardSize.height)
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.view.frame.origin.y += (keyboardSize.height)
        }
    }
    
    
}
