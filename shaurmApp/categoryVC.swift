//
//  categoryVC.swift
//  shaurmApp
//
//  Created by Tim on 2015-08-28.
//  Copyright (c) 2015 Nikolaev Igor. All rights reserved.
//

import UIKit

private let tableHeaderHeight: CGFloat = 180.0

class categoryVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var categoryImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var catTitleLabel: UILabel!
    
    var categoryId = String()
    var catImage = UIImage()
    var headerView: UIView!
    
    var templesArray = []
    var templeTitlesArray = [String]()
    
    var resultCellId = String()
    var resultCellTitle = String()

    //var catTitleLabel: UILabel!


    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        self.automaticallyAdjustsScrollViewInsets = false;
        
        let width = UIScreen.mainScreen().bounds.width
        let height = UIScreen.mainScreen().bounds.height
        
        tableView.alpha = 0
        tableView.frame.size.height = height - 150
        tableView.frame.size.width = width

        let spinner = ShawarmaSpinnerView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.view.addSubview(spinner)
        spinner.center = self.view.center
        spinner.start()
        
        
        categoryImage.image = catImage
        categoryImage.contentMode = .ScaleAspectFill
        categoryImage.clipsToBounds =  true
        //categoryImage.frame.size = CGSize(width: width, height: 220)
        
        // ADDING A TITLE LABEL
        
        self.catTitleLabel.textColor = UIColor.whiteColor()
        self.catTitleLabel.adjustsFontSizeToFitWidth = true
        self.catTitleLabel.layer.zPosition = 25
        self.catTitleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 21)
        
        
        self.title = "Рекомендации"
        
        PFQuery(className: "Category").getObjectInBackgroundWithId(self.categoryId) {
            (object: PFObject?, error: NSError?) -> Void in
            
            if let object = object {
                
                
                let title: AnyObject? = object.valueForKey("title")

                
                self.catTitleLabel.text = title as? String
                self.catTitleLabel.sizeToFit()
                //self.catTitleLabel.center = self.categoryImage.center
                //self.catTitleLabel.center.x = width/2
                
                PFQuery(className: "Temple").whereKey("cat", equalTo: object).findObjectsInBackgroundWithBlock{
                    (objects: [PFObject]?, error: NSError?) -> Void in
                    
                    if let objects = objects {
                        
                        for o in objects {
                            self.templeTitlesArray.append(o.valueForKey("title") as! String)
                        }
                        self.templesArray = objects
                        self.tableView.reloadData()
                        spinner.hidden = true
                        UIView.animateWithDuration(0.3, animations: {self.tableView.alpha = 1.0})
                        spinner.stop()


                    }
                }
            }
        }
        
        
        headerView = tableView.tableHeaderView
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        
        headerView.addSubview(self.catTitleLabel)
        tableView.contentInset = UIEdgeInsets(top: tableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -tableHeaderHeight)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return templesArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:templeCell = tableView.dequeueReusableCellWithIdentifier("Temple") as! templeCell
        
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        
        if templesArray.count != 0 {
        self.templesArray[indexPath.row].valueForKey("picture")!.getDataInBackgroundWithBlock {
                (imageData:NSData?, error: NSError?) -> Void in
                
                if error == nil {
                    let image = UIImage(data: imageData!)
                    cell.templeImage.image = image
                    cell.templeImage.contentMode = .ScaleAspectFill
            }}

            
            
            cell.templeTitleLabel.text = self.templeTitlesArray[indexPath.row]
            cell.templeId = (templesArray[indexPath.row] as! PFObject).objectId!
            
        }
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "goToNewTempleVC") {
            
            let viewController:newTempleVC = segue.destinationViewController as! newTempleVC
            
            viewController.id = resultCellId
            viewController.templeTitle = resultCellTitle
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! templeCell
        
        resultCellId = cell.templeId
        resultCellTitle = cell.templeTitleLabel.text!
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        

        
        //self.performSegueWithIdentifier("goToTempleVC", sender: self)
        self.performSegueWithIdentifier("goToNewTempleVC", sender: self)

    }
    
    
    func updateHeaderView(){
        var headerRect = CGRect(x: 0, y: -tableHeaderHeight, width: tableView.bounds.width, height: tableHeaderHeight)

        if tableView.contentOffset.y < -tableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        
        headerView.frame = headerRect        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        updateHeaderView()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
