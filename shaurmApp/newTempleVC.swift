//
//  newTempleVC.swift
//  shaurmApp
//
//  Created by Tim on 2015-09-10.
//  Copyright (c) 2015 Nikolaev Igor. All rights reserved.
//

import UIKit

class newTempleVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate,AddCommentDelegate, StarViewDelegate {
    let tableHeaderHeight: CGFloat = 300.0
    var activeCellIndexPath = 0
    
    @IBOutlet weak var subwayLabelWrapper: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var starView: HCSStarRatingView!
    @IBOutlet weak var recentLabel: UILabel!
    @IBOutlet weak var markButton: UIButton!
    
    func addCommentDidFinish(addCommentText: String, controller: addCommentVC) {
        commentText = addCommentText
        controller.navigationController!.popViewControllerAnimated(true)
        self.addCommentAction()
    }
    
    @IBAction func markButtonPressed(sender: AnyObject) {
        UIView.animateWithDuration(0.5, animations: {
            self.totalLabel.hidden = false
            self.recentLabel.hidden = false
            self.markButton.hidden = true
            self.markButton.alpha = 0.0
            self.saveRating(self.starView.value)
            self.refresh()
        })
        
    }
    
    @IBAction func changeValue(sender: AnyObject) {
        print(starView.value)
        self.starView.active = true
        UIView.animateWithDuration(0.5, animations: {
            self.totalLabel.hidden = true
            self.recentLabel.hidden = true
            self.markButton.hidden = false
            self.markButton.alpha = 1.0
        })
    }
    
    
    @IBOutlet weak var mainTableView: UITableView!
    let width = UIScreen.mainScreen().bounds.width
    var headerView: UIView!
    var starWidgetView: UIView!
    
    
    var id = String()
    var templeTitle = String()
    var subway = String()
    var templeRating = CGFloat()
    var commentText = String()
    var menuData = NSArray()
    var templeLocation = CLLocationCoordinate2D()
    var ratingAmount = Int(1)
    var features = ["M", true, true]
    
    
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var templePictureView: UIImageView!
    @IBOutlet weak var templeTitleLabel: UILabel!
    @IBOutlet weak var subwayLabel: UILabel!
    
    //var subwayLabel: UILabel!
    
    var selectedIndexPath:NSIndexPath?
    var resultReviewArray = []
    
    
    func setTableView(){
        self.mainTableView = UITableView(frame: CGRect())
    }
    
    
    override func viewDidLoad(){
        
        
        self.starView.active = false
        self.automaticallyAdjustsScrollViewInsets = false;
        
        
        mainTableView.frame.size = UIScreen.mainScreen().bounds.size
        
        //mainTableView.registerClass(menuCell.self, forCellReuseIdentifier: "menuCell")
        
        mainTableView.registerNib(UINib.init(nibName: "menuCell", bundle: nil), forCellReuseIdentifier: "menuCell")
        mainTableView.registerNib(UINib.init(nibName: "featuresCell", bundle: nil), forCellReuseIdentifier: "featuresCell")
        mainTableView.registerNib(UINib.init(nibName: "addCommentCell", bundle: nil), forCellReuseIdentifier: "addCommentCell")
        mainTableView.registerNib(UINib.init(nibName: "commentCell", bundle: nil), forCellReuseIdentifier: "commentCell")
        mainTableView.registerNib(UINib.init(nibName: "locationCell", bundle: nil), forCellReuseIdentifier: "locationCell")
        
        
        
        mainTableView.backgroundColor = UIColor(red: CGFloat(240.0/255.0), green: CGFloat(240.0/255.0), blue: CGFloat(240.0/255.0), alpha: 1.0)
        mainTableView.separatorInset = UIEdgeInsetsZero
        mainTableView.layoutMargins = UIEdgeInsetsZero
        mainTableView.preservesSuperviewLayoutMargins = false
        mainTableView.separatorStyle = .None
        
        totalLabel.text = "Всего оценок: 1"
        totalLabel.textColor = UIColor.blackColor()
        totalLabel.sizeToFit()
        
        recentLabel.text = "Моя оценка: "
        recentLabel.textColor = UIColor.blackColor()
        recentLabel.sizeToFit()
        
        markButton.setTitle("ОЦЕНИТЬ", forState: UIControlState.Normal)
        markButton.titleLabel?.textAlignment = NSTextAlignment.Center
        markButton.alpha = 0.0
        markButton.hidden = true
        
        self.view.frame.size.width = width
        
        
        self.templeTitleLabel.numberOfLines = 0
        self.templeTitleLabel.center.x = self.view.center.x
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
        super.viewDidLoad()
        
        
    }
    
    
    
    func refresh() {
        
        let spinner = ShawarmaSpinnerView(frame: CGRect(x: self.view.center.x, y: self.view.center.y + 100.0, width: 50, height: 50))
        self.view.addSubview(spinner)
        spinner.start()
        
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        if let rating = userDefaults.valueForKey(self.id) {
            self.recentLabel.text = "Моя оценка: \(rating as! CGFloat)"
        }
        
        PFQuery(className: "Temples2").getObjectInBackgroundWithId(id) {
            (object: PFObject?, error: NSError?) -> Void in
            
            if (object != nil) {
                self.subway = (object!.valueForKey("subway") as? String)!
                
                self.templeTitleLabel.text = object!.valueForKey("title") as? String
                
                
                if let ratingNum = object!.valueForKey("ratingNumber") {
                    self.templeRating = CGFloat(NSNumberFormatter().numberFromString(String(ratingNum))!)/2
                    self.starView.value = self.templeRating
                }
                
                if let geoPoint:PFGeoPoint = object!.valueForKey("location") as? PFGeoPoint {
                    self.templeLocation = CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
                }
                
                if let loadedRatingAmount = object!.valueForKey("ratingAmount") {
                    self.ratingAmount = loadedRatingAmount as! Int
                    self.totalLabel.text = "Всего оценок: \(self.ratingAmount)"
                }
                
                if let menuData = object!.valueForKey("menu") {
                    self.menuData = menuData as! NSArray
                }
                
                
                if let size = object!.valueForKey("size"), hot = object!.valueForKey("hot"), gloves = object!.valueForKey("gloves") {
                    self.features = [size as! String, hot as! Bool, gloves as! Bool]
                }
                
                
                
                self.templeTitleLabel.sizeToFit()
                self.templeTitleLabel.numberOfLines = 0
                
                if let obj = object!.valueForKey("picture") {
                    
                    obj.getDataInBackgroundWithBlock {
                        (imageData:NSData?, error: NSError?) -> Void in
                        
                        if error == nil {
                            let image = UIImage(data: imageData!)
                            self.templePictureView.image = image
                        }
                    }
                }
                
                self.subwayLabel.text = self.subway
                self.subwayLabel.textColor = SHMManager.colorForStation(self.subwayLabel.text)
                self.subwayLabel.sizeToFit()
                self.subwayLabel.backgroundColor = UIColor.whiteColor()
                self.subwayLabelWrapper.layer.masksToBounds = true
                self.subwayLabelWrapper.layer.cornerRadius = 10
                self.subwayLabelWrapper.layer.zPosition = 100
                
                
                PFQuery(className: "Review").whereKey("temple", equalTo: object!).findObjectsInBackgroundWithBlock({ ( objects:[PFObject]?, error:NSError?) -> Void in
                    if let objects = objects{
                        self.resultReviewArray = objects
                    }
                    
                    self.mainTableView.reloadData()
                    
                })
            }
            
            UIView.animateWithDuration(0.5, animations: {
                self.templeTitleLabel.alpha = 1.0
                self.mainTableView.alpha = 1.0
                self.subwayLabel.alpha = 1.0
                self.templePictureView.alpha = 1.0
            })
            spinner.stop()
            spinner.hidden = true
            spinner.removeFromSuperview()
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 0{
            return 50
        }
        
        if indexPath.row == 2{
            //menu cell
            
            if self.activeCellIndexPath == indexPath.row {
                
                return menuCell.expandedHeight
            }
            else{
                return menuCell.defaultHeight
            }
        }
        
        
        if indexPath.row == 1{
            return 70
        }
        
        
        if indexPath.row >= 3 && indexPath.row <= 5 {
            if resultReviewArray.count < (indexPath.row - 2) {
                return 0
            }else{
                if indexPath.row == 3{
                    return 125
                }
            }
        }
        
        if indexPath.row == 6{
            return addCommentCell.defaultHeight
        }
        
        if indexPath.row == 7{
            return 0
        }
        
        return 95
    }
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        //let categories:[String] = ["Размер","Перчатки","Соус","Мастер"]
        
        
        //SEPARATOR
        let separatorView = UIView()
        separatorView.frame = CGRectMake(0, 0, width, 0.7)
        separatorView.backgroundColor = UIColor.lightGrayColor()
        
        if indexPath.row == 0{
            
            let cccell:featuresCell = tableView.dequeueReusableCellWithIdentifier("featuresCell") as! featuresCell
            cccell.setImages(self.features[0] as! String, hot: self.features[1] as! Bool, gloves: self.features[2] as! Bool)
            cccell.frame.size.width = width
            cccell.clipsToBounds = true
            cccell.delegate = self
            cell = cccell
        }
        
        if indexPath.row == 1{
            
            let cccell:locationCell = tableView.dequeueReusableCellWithIdentifier("locationCell") as! locationCell
            cccell.setLabels(self.subway, address: self.templeTitle)
            cell = cccell
            
        }
        
        if indexPath.row == 2{
            let ccell:menuCell = tableView.dequeueReusableCellWithIdentifier("menuCell") as! menuCell
            ccell.delegate = self
            ccell.menuData = self.menuData
            print(self.menuData)
            ccell.refresh()
            cell = ccell
        }
        
        
        
        
        if indexPath.row >= 3 && indexPath.row <= 5 {
            let cccell:commentCell = tableView.dequeueReusableCellWithIdentifier("commentCell") as! commentCell
            cccell.sizeToFit()
            
            
            if resultReviewArray.count != 0 {
                
                if(indexPath.row - 3 < self.resultReviewArray.count){
                    if(indexPath.row != 3){
                        cccell.hideHeader()
                    }
                    
                    
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
            cccell.delegate = self
            cell = cccell
        }
        if indexPath.row == 6{
            let ccell:addCommentCell = tableView.dequeueReusableCellWithIdentifier("addCommentCell") as! addCommentCell
            ccell.seeAllButton.addTarget(self, action: "expandButtonAction", forControlEvents: UIControlEvents.TouchUpInside)
            ccell.expandButton.addTarget(self, action: "addButtonAction", forControlEvents: UIControlEvents.TouchUpInside)
            ccell.delegate = self
            cell = ccell
        }
        if indexPath.row == 7 {
            //            let ccell:locationCell = tableView.dequeueReusableCellWithIdentifier("locationCell") as! locationCell
            //            cell = ccell
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
        
        if indexPath.row == 2{
            self.menuAction()
        }
        
        if indexPath.row == 1{
            self.goToMapAction()
        }
        
        
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
        if indexPath.row == 2{
            (cell as! menuCell).watchFrameChanges()
        }
        
    }
    
    
    func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 2{
            (cell as! menuCell).ignoreFrameChanges()
        }
        
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
        self.dismissStarView()
        
        let text = self.commentText
        
        if text != "" {
            let userDefaults = NSUserDefaults.standardUserDefaults()
            var userNumber = userDefaults.valueForKey("userNumber")
            
            if userNumber == nil {
                
                let count = PFQuery(className: "Gourmand").countObjects(nil) + 1
                let gourmand = PFObject(className:"Gourmand")
                gourmand["count"] = count
                userDefaults.setValue(count, forKey: "userNumber")
                userDefaults.synchronize()
                userNumber = count
                
                gourmand.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        print("user saved")
                    } else {
                        print(error)
                    }
                }
            }
            if let userNumber = userNumber {
                
                let review = PFObject(className:"Review")
                review["comment"] = text
                review["userName"] = "Гурман #\(userNumber)"
                
                PFQuery(className: "Temples2").getObjectInBackgroundWithId(self.id){
                    (object: PFObject?, error: NSError?) -> Void in
                    if error == nil {
                        if let object = object {
                            review["temple"] = object
                        }
                        
                        
                        print(text)
                    }
                    else {
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                    
                    
                    
                    
                    review.saveInBackgroundWithBlock {
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            print("comment saved")
                        } else {
                            print(error)
                        }
                    }
                }
            }
            self.refresh()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "templeToAddComment") {
            
            let vc = segue.destinationViewController as! addCommentVC
            vc.delegate = self
        }
            
        else if (segue.identifier == "templeToComments") {
            
            let viewController:commentsVC = segue.destinationViewController as! commentsVC
            
            viewController.templeId = self.id
        }
            
            
        else if (segue.identifier == "templeToMap") {
            
            let viewController:mapVC = segue.destinationViewController as! mapVC
            viewController.setTempleById(self.id)
            //viewController.setCameraPosition(self.templeLocation.latitude, longitude: self.templeLocation.longitude)
            
        }
    }
    
    
    func menuAction(){
        
        if self.activeCellIndexPath == 2 {
            
            
            self.activeCellIndexPath = 0
            self.mainTableView.beginUpdates()
            self.mainTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 2, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
            self.mainTableView.endUpdates()
            
            //self.mainTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            
        }
        else{
            
            self.activeCellIndexPath = 2
            self.mainTableView.beginUpdates()
            self.mainTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 2, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
            self.mainTableView.endUpdates()
            
            
            //self.mainTableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
        }
        
        
    }
    
    
    func addButtonAction(){
        self.dismissStarView()
        self.performSegueWithIdentifier("templeToAddComment", sender: self)
    }
    
    func goToMapAction(){
        self.dismissStarView()
        self.performSegueWithIdentifier("templeToMap", sender: self)
    }
    
    
    func expandButtonAction(){
        self.dismissStarView()
        self.performSegueWithIdentifier("templeToComments", sender: self)
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        self.mainTableView.reloadData()
        return true
    }
    
    func dismissStarView(){
        if self.starView.active == true {
            UIView.animateWithDuration(0.5, animations: {
                self.totalLabel.hidden = false
                self.recentLabel.hidden = false
                self.markButton.hidden = true
                self.markButton.alpha = 0.0
                self.starView.value = self.templeRating
                self.starView.active = false
            })
        }
    }
    
    func dismissStarView(controller:AnyObject){
        if self.starView.active == true {
            self.dismissStarView()
        }
    }
    
    
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.shadowImage = UIImage.init()
        self.navigationController?.view.backgroundColor = UIColor.clearColor()
        
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
    }
    
    func saveRating(ratingNumber: CGFloat) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setValue(ratingNumber, forKey: self.id)
        userDefaults.synchronize()
        
        let averageRating = (CGFloat(self.templeRating)*(CGFloat(self.ratingAmount)) + ratingNumber)/CGFloat(self.ratingAmount + 1)
        
        print("RATING")
        print(averageRating)
        
        
        PFQuery(className: "Temples2").getObjectInBackgroundWithId(self.id) {
            (object: PFObject?, error: NSError?) -> Void in
            
            object?.setValue(Int(averageRating*2), forKey: "ratingNumber")
            object?.setValue(self.ratingAmount + 1, forKey: "ratingAmount")
            object?.setValue("\(Int(averageRating*2))/10", forKey: "ratingString")
            object?.saveInBackground()
        }
        
        
        
    }
    
}
