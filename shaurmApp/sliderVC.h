//
//  sliderVC.h
//  shaurmApp
//
//  Created by Igor Nikolaev on 07.09.15.
//  Copyright (c) 2015 Nikolaev Igor. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "sliderDelegate.h"
#import "containerDelegate.h"

@interface sliderVC : UIViewController <UITableViewDataSource, UITableViewDelegate, sliderDelegate>

@property (weak, nonatomic) id <containerDelegate> containerDelegate;

@end