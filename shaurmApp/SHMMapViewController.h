//
//  SHMMapViewController.h
//  shaurmApp
//
//  Created by Igor Nikolaev on 20/03/16.
//  Copyright © 2016 NikolaevIgor. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMaps;
#import "SHMTemple.h"

@interface SHMMapViewController : UIViewController

- (instancetype)initWithDelegate:(id)delegate;
- (void)setPinsForTemples:(NSArray *)temples;
- (void)setPinForTemple:(SHMTemple *)temple;

@end
