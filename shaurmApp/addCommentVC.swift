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
        delegate!.addCommentDidFinish(commentTextView.text, controller: self)
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
        self.navigationController?.navigationBar.translucent = false
    }
}
