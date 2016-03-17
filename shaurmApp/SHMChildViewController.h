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

@property (weak, nonatomic) NSArray *textArray;
@property (weak, nonatomic) NSArray *imgArray;
@property (assign, nonatomic) NSInteger index;
@property (weak, nonatomic) IBOutlet UIImageView *forkImage;
@property (weak, nonatomic) IBOutlet UILabel *screenNumber;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (weak, nonatomic) IBOutlet UIImageView *tutImage;
@property (weak, nonatomic) IBOutlet UILabel *appetiteLabel;
@property (weak, nonatomic) IBOutlet UILabel *hcocbLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgBottomConstr;
@property (weak, nonatomic) id <tutorialDelegate> delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *appetiteTopConstr;

@end
