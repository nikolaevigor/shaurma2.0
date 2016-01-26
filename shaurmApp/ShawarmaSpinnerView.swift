//
//  ShawarmaSpinnerView.swift
//  shaurmApp
//
//  Created by Tim on 2015-09-06.
//  Copyright (c) 2015 Nikolaev Igor. All rights reserved.
//

import UIKit

class ShawarmaSpinnerView: UIView {
    
    var spinnerImageView:UIImageView!
    var rotating = Bool()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        spinnerImageView = UIImageView(frame: CGRect(x: frame.origin.x + 5, y: frame.origin.y + 5, width: frame.width-10, height: frame.height-10))
        spinnerImageView.image = UIImage(named: "spinner")
        
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = self.frame.size.width/2
        self.addSubview(spinnerImageView)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func start() {
        rotating = true
        
        rotate()
    }
    
    func rotate() {
        UIView.animateWithDuration(0.8,
            delay: 0.0,
            options: .CurveLinear,
            animations: {self.spinnerImageView.transform = CGAffineTransformRotate(self.spinnerImageView.transform, 3.1415926)},
            completion: {finished in if self.rotating { self.rotate() }})
    }
    
    
    func stop() {
        rotating = false
    }
    


    
}