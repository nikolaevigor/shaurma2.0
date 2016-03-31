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
            let index = Int32(index)
            
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cellMenu")!
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.layoutMargins = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clearColor()
        
        cell.frame = CGRect(x: 0, y: 0, width: tblMenuOptions.frame.width, height: cell.frame.height)
        
//        let lblTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
//        lblTitle.text = arrayMenuOptions[indexPath.row]["title"]!
        
        if(indexPath.row == 2){
            let width = tblMenuOptions.frame.width*0.8
            let height = cell.frame.height*0.5
            
            
            let FacebookButton = UIButton(frame: CGRect(x: tblMenuOptions.frame.midX - width/2, y: cell.frame.height/2 - height/2, width: width, height: height))
            
            FacebookButton.backgroundColor = UIColor.blueColor()
            cell.addSubview(FacebookButton)
        }
        
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