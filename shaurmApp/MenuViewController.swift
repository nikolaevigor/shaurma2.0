//
//  SideMenuViewController.swift
//  shaurmApp
//
//  Created by Tim on 2016-03-31.
//  Copyright © 2016 NikolaevIgor. All rights reserved.
//

import UIKit

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(index : Int32)
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /**
    *  Array to display menu options
    */
    
    @IBOutlet var tblMenuOptions: UITableView!
    /**
    *  Transparent button to hide menu
    */
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    
    /**
    *  Array containing menu options
    */
    var arrayMenuOptions = [Dictionary<String,String>]()
    

    
    /**
    *  Delegate of the MenuVC
    */
    var delegate : SlideMenuDelegate?
    
    override func viewDidLoad() {
        self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.width/3, height: UIScreen.mainScreen().bounds.width)
        super.viewDidLoad()
        tblMenuOptions.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        updateArrayMenuOptions()
    }
    
    func updateArrayMenuOptions(){
        arrayMenuOptions.append(["title":"One", "icon":"HomeIcon"])
        arrayMenuOptions.append(["title":"Two", "icon":"PlayIcon"])
        arrayMenuOptions.append(["title":"Three", "icon":"CameraIcon"])
        tblMenuOptions.reloadData()
    }
    
    func onCloseMenuClick(index: Int){
        
        if (self.delegate != nil) {
            var index = Int32(index)

            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        

//        
//        UIView.animateWithDuration(0.3, animations: { () -> Void in
//            self.view.frame = CGRectMake(-UIScreen.mainScreen().bounds.size.width, 0, UIScreen.mainScreen().bounds.size.width/3,UIScreen.mainScreen().bounds.size.height)
//            self.view.layoutIfNeeded()
//            self.view.backgroundColor = UIColor.clearColor()
//            }, completion: { (finished) -> Void in
//                self.view.removeFromSuperview()
//                self.removeFromParentViewController()
//        })
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cellMenu")!
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clearColor()
        
        let lblTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
//        let imgIcon : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView
//        imgIcon.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
        lblTitle.text = arrayMenuOptions[indexPath.row]["title"]!
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        print("Cool")
        self.onCloseMenuClick(indexPath.row)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
}