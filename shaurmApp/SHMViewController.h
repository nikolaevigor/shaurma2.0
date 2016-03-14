//
//  SHMViewController.h
//  shaurmApp
//
//  Created by Igor Nikolaev on 14/03/16.
//  Copyright © 2016 NikolaevIgor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tutorialDelegate.h"

@interface SHMViewController : UIViewController <UIPageViewControllerDataSource, tutorialDelegate>

@property (strong, nonatomic) UIPageViewController *pageController;

@end
