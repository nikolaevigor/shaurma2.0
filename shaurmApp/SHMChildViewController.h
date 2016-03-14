//
//  SHMChildViewController.h
//  shaurmApp
//
//  Created by Igor Nikolaev on 14/03/16.
//  Copyright © 2016 NikolaevIgor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tutorialDelegate.h"

@interface SHMChildViewController : UIViewController

@property (assign, nonatomic) NSInteger index;
@property (weak, nonatomic) IBOutlet UILabel *screenNumber;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (weak, nonatomic) id <tutorialDelegate> delegate;

@end
