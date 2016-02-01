//
//  SecondViewController.h
//  shaurmApp
//
//  Created by Igor Nikolaev on 27/08/15.
//  Copyright (c) 2015 Nikolaev Igor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCalloutView.h"
@import GoogleMaps;
@import CoreLocation;
#import "mapDelegate.h"

@interface mapVC : UIViewController <GMSMapViewDelegate, CLLocationManagerDelegate, mapDelegate>
@property (nonatomic) BOOL setNearest;
-(void)setTempleById:(NSString *)templeId;
@end

