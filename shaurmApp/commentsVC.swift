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
        if indexPath.row == 0{
            return max(125, heightForView(commentTextArray[indexPath.row],font: UIFont(name: "Montserrat", size: 18)!, width: 0.8*(self.screenWidth)) + 35)
        }
        
        return max(110, heightForView(commentTextArray[indexPath.row],font: UIFont(name: "Montserrat", size: 18)!, width: 0.8*(self.screenWidth)) + 10)
    }
    
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:commentCell = mainTableView.dequeueReusableCellWithIdentifier("commentCellID") as! commentCell
        cell.sizeToFit()
        cell.userInteractionEnabled = false
        if commentsArray.count != 0 {
            if(indexPath.row != 0){
                cell.hideHeader()
            }
            
            cell.userNameLabel?.text = userNamesArray[indexPath.row]
            cell.dateLabel?.text = datesArray[indexPath.row]
            cell.commentTextLabel?.text = commentTextArray[indexPath.row]
            
            cell.commentTextLabel.sizeToFit()
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
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
}
