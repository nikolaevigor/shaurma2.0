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
    var spinnerTimer = NSTimer()
    
    override init(frame: CGRect) {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        super.init(frame: CGRect(x: screenSize.size.width/2 - 25, y: screenSize.size.height/2 - 15, width: 50, height: 50))
        spinnerImageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 40, height: 40))
        spinnerImageView.image = UIImage(named: "shaurma")
        
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = self.frame.size.width/2
        self.addSubview(spinnerImageView)
        
        spinnerTimer = NSTimer(timeInterval: 15.0, target: self, selector: "throwWarning", userInfo: nil, repeats: false)
        NSRunLoop.currentRunLoop().addTimer(spinnerTimer, forMode: NSRunLoopCommonModes)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func start() {
        rotating = true
        rotate()
    }
    
    func throwWarning(){
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        self.frame = CGRect(x: screenSize.size.width/2 - 60, y: screenSize.size.height/2 - 65, width: 120, height: 85)
        self.layer.cornerRadius = self.frame.size.width/10

        let warningLabel = UILabel(frame: CGRect(x: self.frame.width/2 - 50, y: self.frame.height - 35, width: 100, height: 40))
        warningLabel.font = UIFont(name: "Montserrat-Light", size: 14)
        warningLabel.textColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1.0)
        warningLabel.text = "нет соединения"
        warningLabel.sizeToFit()
        
        
        let crossImage = UIImageView(frame: CGRect(x: self.frame.width/2 - 18, y: 10, width: 36, height: 36))
        crossImage.image = UIImage(named: "cross")
        
        self.addSubview(warningLabel)
        self.addSubview(crossImage)


        self.spinnerImageView.removeFromSuperview()
        
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