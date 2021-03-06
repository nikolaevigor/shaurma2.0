//
//  locationCell.swift
//  shaurmApp
//
//  Created by Tim on 2016-01-27.
//  Copyright © 2016 NikolaevIgor. All rights reserved.
//

import UIKit

class locationCell: UITableViewCell {
    
    @IBOutlet weak var subwayLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var goToMapButton: UIButton!
    @IBAction func goToMap(sender: AnyObject) {
        
    }
    
    func setLabels(subway: String, address: String){
        if subway == "Нет метро"{
            self.subwayLabel.text = subway
        }
        else if !SHMManager.isStation(subway) {
            self.subwayLabel.text = "ст. \(subway)"
        }
        else{
            self.subwayLabel.text = "м. \(subway)"
        }
        self.addressLabel.text = address
    }
}
