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
        spinnerImageView = UIImageView(frame: frame)
        spinnerImageView.image = UIImage(named: "spinner")
        
        
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