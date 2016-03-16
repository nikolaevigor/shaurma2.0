//
//  commentsVC.swift
//
//
//  Created by Tim on 2016-01-04.
//
//

import UIKit



class commentsVC: UITableViewController {
    
    var templeId = String()
    
    var commentsArray = [PFObject]()
    var userNamesArray = [String]()
    var datesArray = [String]()
    var commentTextArray = [String]()
    var resultCellId = String()
    var screenWidth = CGFloat()
    var heightsArray:NSMutableArray = [0]
    
    @IBOutlet var mainTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.screenWidth = UIScreen.mainScreen().bounds.width
        let height = UIScreen.mainScreen().bounds.height
        tableView.frame.size.height = height - 150
        tableView.frame.size.width = self.screenWidth
        mainTableView.registerNib(UINib.init(nibName: "commentCell", bundle: nil), forCellReuseIdentifier: "commentCellID")
        self.refresh()
    }
    
    func refresh() {
        
        let spinner = ShawarmaSpinnerView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(spinner)
        spinner.center.x = self.view.center.x
        spinner.center.y = self.view.center.y + 100.0
        
        spinner.start()
        
        
        PFQuery(className: "Temples2").getObjectInBackgroundWithId(self.templeId) {
            (object: PFObject?, error: NSError?) -> Void in
            
            if let object = object {
                
                PFQuery(className: "Review").whereKey("temple", equalTo: object).findObjectsInBackgroundWithBlock({
                    (objects:[PFObject]?, error: NSError?) -> Void in
                    
                    
                    if (objects != nil) {
                        self.commentsArray = objects!
                        for comment in self.commentsArray {
                            if let userName = comment.valueForKey("userName") {
                                self.userNamesArray.append(userName as! String)
                            }
                            if let commentDate = comment.valueForKey("createdAt") as? NSDate {
                                let dateForm = NSDateFormatter()
                                dateForm.dateStyle = NSDateFormatterStyle.LongStyle
                                self.datesArray.append(dateForm.stringFromDate(commentDate))
                            }
                            if let commentText = comment.valueForKey("comment") as? String{
                                self.commentTextArray.append(commentText)
                            }
                        }
                    }
                    self.mainTableView.reloadData()
                })
            }
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            self.mainTableView.reloadData()
        }
        
        spinner.hidden = true
        UIView.animateWithDuration(0.5, animations: {
            //            self.templeTitleLabel.alpha = 1.0
            //            self.mainTableView.alpha = 1.0
            //            self.subwayLabel.alpha = 1.0
            //            self.templePictureView.alpha = 1.0
        })
        spinner.stop()
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsArray.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        if screenWidth == 320 {
            if indexPath.row == 0{
                
                if self.heightsArray.count > 0 {
                    return max(125, heightForView(commentTextArray[indexPath.row], font: UIFont(name: "Montserrat", size: CGFloat(15))!, width: CGFloat(320)) + 140.0)
                }
                else{return 125}
                
            }else{
                
                if self.heightsArray.count > indexPath.row {
                    return max(110, 1.1*(self.heightsArray[indexPath.row] as! CGFloat) + 100.0)
                }
                else{ return 110}
                
            }
        }else{
            if indexPath.row == 0{
                
                if self.heightsArray.count > 0 {
                    return max(125, self.heightsArray[indexPath.row] as! CGFloat + 143.0)
                }
                else{return 125}
                
            }else
                
                if self.heightsArray.count > indexPath.row {
                    return max(110, self.heightsArray[indexPath.row] as! CGFloat + 100.0)
                }
                else{ return 110}
        }
    }
    
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:commentCell = mainTableView.dequeueReusableCellWithIdentifier("commentCellID") as! commentCell
        cell.userInteractionEnabled = false
        if commentsArray.count != 0 {
            if(indexPath.row != 0){
                cell.hideHeader()
            }
            
            cell.userNameLabel?.text = userNamesArray[indexPath.row]
            cell.dateLabel?.text = datesArray[indexPath.row]
            cell.commentTextLabel?.text = commentTextArray[indexPath.row]
            
            cell.commentTextLabel.sizeToFit()
            self.heightsArray.insertObject(cell.commentTextLabel.frame.height, atIndex: indexPath.row)
            
            cell.dateLabel.sizeToFit()
            cell.userNameLabel.sizeToFit()
        }
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        
        return cell
    }
    
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.translucent = false
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        
        let newWidth = width - 40
        
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, newWidth, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        
        print(label.frame.height)
        return label.frame.height
        
    }
    
    
    
}
