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
    
    var resultCellId = String()
    
    @IBOutlet var mainTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        self.automaticallyAdjustsScrollViewInsets = false;
        
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.init(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage.init()
        self.navigationController?.view.backgroundColor = UIColor.clearColor()
        
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        let width = UIScreen.mainScreen().bounds.width
        let height = UIScreen.mainScreen().bounds.height
        
        tableView.alpha = 0
        tableView.frame.size.height = height - 150
        tableView.frame.size.width = width

        
        
        
    
        
        mainTableView.registerNib(UINib.init(nibName: "commentCell", bundle: nil), forCellReuseIdentifier: "commentCellID")
        
        self.refresh()

        
    }
    
    func refresh() {
        
        let spinner = ShawarmaSpinnerView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(spinner)
        spinner.center.x = self.view.center.x
        spinner.center.y = self.view.center.y + 100.0
        
        spinner.start()
        
        print(self.templeId)
    
        PFQuery(className: "Temples2").getObjectInBackgroundWithId(self.templeId) {
            (object: PFObject?, error: NSError?) -> Void in
            
            if let object = object {
                
        PFQuery(className: "Review").whereKey("temple", equalTo: object).findObjectsInBackgroundWithBlock({
            (objects:[PFObject]?, error: NSError?) -> Void in
            
            
            if (objects != nil) {
                self.commentsArray = objects!
                print("obj")
                print(self.commentsArray.count)

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
        return 70
    }
    
override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath){
        
        if commentsArray.count != 0 {
            if let userName = self.commentsArray[indexPath.row].valueForKey("userName") {
                (cell as! commentCell).userNameLabel?.text = userName as? String
            }
            
            if let date = self.commentsArray[indexPath.row].valueForKey("createdAt") {
                (cell as! commentCell).dateLabel?.text = date as? String
            }
            
            if let commentText = self.commentsArray[indexPath.row].valueForKey("commentText") {
                (cell as! commentCell).commentTextLabel?.text = String(commentText)
                
            }
            
            
            
            
            (cell as! commentCell).commentTextLabel.sizeToFit()
            (cell as! commentCell).dateLabel.sizeToFit()
            (cell as! commentCell).userNameLabel.sizeToFit()
            
        }
    
    
    
    }
    
    
    override
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:commentCell = mainTableView.dequeueReusableCellWithIdentifier("commentCellID") as! commentCell
        cell.sizeToFit()
        
        
        
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        
        return cell
    }
    

    

    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
