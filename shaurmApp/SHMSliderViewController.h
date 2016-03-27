//
//  SHMSliderViewController.h
//  shaurmApp
//
//  Created by Igor Nikolaev on 20/03/16.
//  Copyright © 2016 NikolaevIgor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHMSliderViewController : UIViewController

- (instancetype)initWithDelegate:(id)delegate;
- (void)setTableWithTemples:(NSArray *)temples;

@end
