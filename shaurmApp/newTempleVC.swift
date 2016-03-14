//
//  newTempleVC.swift
//  shaurmApp
//
//  Created by Tim on 2015-09-10.
//  Copyright (c) 2015 Nikolaev Igor. All rights reserved.
//

import UIKit

class newTempleVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate,AddCommentDelegate, StarViewDelegate {
    let tableHeaderHeight: CGFloat = UIScreen.mainScreen().bounds.width + 20
    var activeCellIndexPath = 0
    
    @IBOutlet weak var subwayLabelWrapper: UIView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var starView: HCSStarRatingView!
    @IBOutlet weak var recentLabel: UILabel!
    @IBOutlet weak var markButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    
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
            self.saveRating(self.starView.value*2)
            
        })
        
    }
    
    @IBAction func changeValue(sender: AnyObject) {
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
    var features = ["", 2, 2]
    
    
    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var templePictureView: UIImageView!
    @IBOutlet weak var templeTitleLabel: UILabel!
    @IBOutlet weak var subwayLabel: UILabel!
    
    //var subwayLabel: UILabel!
    
    var selectedIndexPath:NSIndexPath?
    var resultReviewArray = []
    var reviewTextArray = [String]()
    var reviewDateArray = [String]()
    var reviewUserArray = [String]()
    var menuHeight = CGFloat()
    
    var screenWidth = CGFloat()
    
    
    func setTableView(){
        self.mainTableView = UITableView(frame: CGRect())
    }
    
    
    override func viewDidLoad(){
        self.screenWidth = UIScreen.mainScreen().bounds.width
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
        
        recentLabel.text = "Моя оценка: нет"
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
            let curRating = (rating as! CGFloat)
            self.recentLabel.text = "Моя оценка: \(curRating)"
            self.templeRating = curRating
        }
        
        PFQuery(className: "Temples2").getObjectInBackgroundWithId(id) {
            (object: PFObject?, error: NSError?) -> Void in
            
            if (object != nil) {
                self.subway = (object!.valueForKey("subway") as? String)!
                if self.subway == "Subway_Name" {
                    self.subway = "Нет метро"
                }
                
                
                self.templeTitleLabel.text = object!.valueForKey("title") as? String
                
                
                if let ratingNum = object!.valueForKey("ratingNumber") {
                    self.templeRating = CGFloat(NSNumberFormatter().numberFromString(String(ratingNum))!)
                    self.starView.value = self.templeRating/2
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
                
                if let priceValue = object!.valueForKey("price") {
                    self.priceLabel.text = String(format: "%@ ₽", String(priceValue))
                    self.priceLabel.sizeToFit()
                }
                
                if let size = object!.valueForKey("size"), hot = object!.valueForKey("hot"), gloves = object!.valueForKey("gloves") {
                    self.features = [size as! String, NSNumber.init(bool: hot as! Bool), NSNumber.init(bool: gloves as! Bool)]
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
                else{
                    self.templeTitleLabel.textColor = UIColor.darkGrayColor()
                    self.priceLabel.textColor = UIColor.darkGrayColor()
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
                        
                        for review in self.resultReviewArray {
                            let commentDate:NSDate! = review.valueForKey("createdAt") as? NSDate
                            let dateForm = NSDateFormatter()
                            dateForm.dateStyle = NSDateFormatterStyle.LongStyle
                            let commentDateStr = dateForm.stringFromDate(commentDate)
                            self.reviewDateArray.append(commentDateStr)
                            self.reviewTextArray.append((review.valueForKey("comment") as? String)!)
                            self.reviewUserArray.append((review.valueForKey("userName") as? String)!)
                        }
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
                
                return self.menuHeight
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
                    return max(125, heightForView(reviewTextArray[indexPath.row - 3],font: UIFont(name: "Montserrat", size: 15)!, width: self.screenWidth ) + 100)
                }
                else{
                    return max(110, heightForView(reviewTextArray[indexPath.row - 3],font: UIFont(name: "Montserrat", size: 15)!, width: self.screenWidth) + 80)
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
            cccell.setImages(self.features[0] as! String, hot: self.features[1] as! Int, gloves: self.features[2] as! Int)
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
            ccell.refresh()
            self.menuHeight = ccell.getCellHeight()
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
                    cccell.dateLabel.text = self.reviewDateArray[indexPath.row-3]
                    cccell.commentTextLabel.text = self.reviewTextArray[indexPath.row-3]
                    cccell.userNameLabel.text = self.reviewUserArray[indexPath.row-3]
                    cccell.commentTextLabel.numberOfLines = 4
                    
                    let currentSize = cccell.commentTextLabel.frame.size
                    let origin = cccell.commentTextLabel.frame.origin
                    cccell.commentTextLabel.frame = CGRect(origin: origin, size: CGSize(width: currentSize.width, height: min(60, currentSize.height)))
                    
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
            
        }
        else{
            
            self.activeCellIndexPath = 2
            self.mainTableView.beginUpdates()
            self.mainTableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 2, inSection: 0)], withRowAnimation: UITableViewRowAnimation.None)
            self.mainTableView.endUpdates()
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
        var firstTime = true
        var averageRating = CGFloat()
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let myCurrentMark = userDefaults.valueForKey(self.id)
        
        if myCurrentMark != nil {
            firstTime = false
            averageRating = (CGFloat(self.templeRating)*(CGFloat(self.ratingAmount)) - (myCurrentMark as! CGFloat) + ratingNumber)/CGFloat(self.ratingAmount)
        }
        else{
            averageRating = (CGFloat(self.templeRating)*(CGFloat(self.ratingAmount)) + ratingNumber)/CGFloat(self.ratingAmount + 1)
        }
        
        userDefaults.setValue(ratingNumber, forKey: self.id)
        userDefaults.synchronize()
        
        
        PFQuery(className: "Temples2").getObjectInBackgroundWithId(self.id) {
            (object: PFObject?, error: NSError?) -> Void in
            
            if firstTime {
                object?.setValue(self.ratingAmount + 1, forKey: "ratingAmount")
            }
            
            object?.setValue(Int(averageRating), forKey: "ratingNumber")
            object?.setValue("\(Int(averageRating))/10", forKey: "ratingString")
            object?.saveInBackground()
            self.refresh()
        }
        
        self.templeRating = averageRating
        
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let newWidth = width - 40
        
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, newWidth, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return min(80, label.frame.height)
        
    }
    
    
    
}
