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
        
        
        //self.tabBarController!.tabBar.barStyle = UIBarStyle.Black
        
        
        //UITabBar.appearance().barStyle = UIBarStyle.Black
        
        
        self.tabBarController
        
        resultsTable.alpha = 0
        //resultsTable.backgroundColor = UIColor.darkTextColor()
        resultsTable.separatorColor = UIColor.blackColor()
        
        self.automaticallyAdjustsScrollViewInsets = false;
        
        
        let spinner = ShawarmaSpinnerView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
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
                    for o in objects {
                        
                                                
                        
                        self.resultsCategoryTitleArray.append(o.valueForKey("title") as! String)
                        self.resultsCategoryImageFiles.append(o["image"] as! PFFile)
                        self.resultsCategoryIdArray.append(o.objectId!)

                        
                        self.resultsTable.reloadData()
                        
                        spinner.hidden = true
                        UIView.animateWithDuration(0.3, animations: {self.resultsTable.alpha = 1.0})
                        spinner.stop()
                    }}
            }
            
             else {
                //print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultsCategoryTitleArray.count
    }
    
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 180
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:reviewCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! reviewCell
        
        cell.categoryTitleLabel.text = self.resultsCategoryTitleArray[indexPath.row]
        cell.categoryTitleLabel.backgroundColor = UIColor.clearColor()
        cell.categoryTitleLabel.textColor = UIColor.whiteColor()
        cell.categoryTitleLabel.sizeToFit()
        //cell.categoryTitleLabel.center = cell.contentView.center
        //cell.categoryTitleLabel.adjustsFontSizeToFitWidth = true
        //cell.categoryTitleLabel.layer.zPosition = 25
        //cell.categoryTitleLabel.font = UIFont(name: "HelveticaNeue", size: 25)

        
        
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
            
            //print(resultCellCatImage.description)
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
