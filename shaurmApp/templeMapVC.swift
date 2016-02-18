//
//  templeMapVC.swift
//  shaurmApp
//
//  Created by Tim on 2016-01-27.
//  Copyright © 2016 NikolaevIgor. All rights reserved.
//

import Foundation


class templeMapVC: UIViewController {
    
    var map:mapVC!
    

    override func viewDidLoad(){
        super.viewDidLoad()
        self.map = mapVC.init()
    
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.translucent = false
    }

}