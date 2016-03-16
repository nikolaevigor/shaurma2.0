//
//  reviewVC.swift
//  shaurmApp
//
//  Created by Tim on 2015-08-27.
//  Copyright (c) 2015 Nikolaev Igor. All rights reserved.
//

import UIKit

class reviewVC: UIViewController {
    
    var resultsCategoryTitleArray = [String]()
    var resultsCategoryImageFiles = [PFFile]()
    var resultsCategoryTemples = [PFObject]()
    var resultsCategoryIdArray = [String]()
    
    
    var resultCellCatTitle = String()
    var resultCellCatImage =  UIImage()
    var resultCellCatId = String()
    
    //@IBOutlet weak var tapBar: UITabBarItem!
    
    
    @IBOutlet weak var resultsTable: UITableView!
    @IBOutlet weak var navTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        
        
        resultsTable.backgroundColor = UIColor(red: CGFloat(240.0/255.0), green: CGFloat(240.0/255.0), blue: CGFloat(240.0/255.0), alpha: 1.0)
        
        resultsTable.alpha = 0
        resultsTable.separatorColor = UIColor.blackColor()
        
        self.automaticallyAdjustsScrollViewInsets = false;
        
        
        let spinner = ShawarmaSpinnerView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        self.view.addSubview(spinner)
        spinner.center = self.view.center
        spinner.start()
        
        
        
        // RETREIVING CATEGORIES
        
        navTitle.title = "Обзор"
        
        
        let query = PFQuery(className:"Category")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    self.resultsCategoryTitleArray = Array(count: objects.count, repeatedValue: String())
                    self.resultsCategoryImageFiles = Array(count: objects.count, repeatedValue: PFFile(data: NSData())!)
                    self.resultsCategoryIdArray = Array(count: objects.count, repeatedValue: String())
                    
                    for o in objects {
                        self.resultsCategoryTitleArray[o.valueForKey("order") as! Int] = o.valueForKey("title") as! String
                        self.resultsCategoryImageFiles[o.valueForKey("order") as! Int] = o["image"] as! PFFile
                        self.resultsCategoryIdArray[o.valueForKey("order") as! Int] = o.objectId!
                          
                    }}
            }
                
            else {
                //print("Error: \(error!) \(error!.userInfo)")
            }
            self.resultsTable.reloadData()
            
            spinner.hidden = true
            UIView.animateWithDuration(0.3, animations: {self.resultsTable.alpha = 1.0})
            spinner.stop()
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsCategoryTitleArray.count
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 185
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:reviewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! reviewCell
        
        cell.categoryTitleLabel.text = self.resultsCategoryTitleArray[indexPath.row]
        cell.categoryTitleLabel.backgroundColor = UIColor.clearColor()
        cell.categoryTitleLabel.textColor = UIColor.whiteColor()
        cell.categoryTitleLabel.sizeToFit()
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        
        
        resultsCategoryImageFiles[indexPath.row].getDataInBackgroundWithBlock {
            (imageData:NSData?, error: NSError?) -> Void in
            
            if error == nil {
                let image = UIImage(data: imageData!)
                cell.categoryImage.image = image
                self.resultCellCatImage = image!
                cell.categoryImage.contentMode = .ScaleAspectFill
            }
        }
        return cell
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "goToCategoryVC") {
            
            let viewController:categoryVC = segue.destinationViewController as! categoryVC
            viewController.categoryId = resultCellCatId
            viewController.catImage = resultCellCatImage
            //print("we")
            
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! reviewCell
        
        resultCellCatTitle = cell.categoryTitleLabel.text!
        resultCellCatImage = cell.categoryImage.image!
        resultCellCatId = self.resultsCategoryIdArray[indexPath.row]
        
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.performSegueWithIdentifier("goToCategoryVC", sender: self)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
