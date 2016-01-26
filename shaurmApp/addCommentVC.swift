//
//  addCommentVC.swift
//  shaurmApp
//
//  Created by Tim Galiullin on 2016-01-22.
//  Copyright © 2016 NikolaevIgor. All rights reserved.
//

import UIKit

class addCommentVC: UIViewController {
    
    @IBAction func OKButtonAction(sender: AnyObject) {
        self.commentTextView.resignFirstResponder()
    }

    @IBOutlet weak var OKButton: UIBarButtonItem!
    @IBOutlet weak var commentTextView: UITextView!
    
    var delegate:AddCommentDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.commentTextView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
