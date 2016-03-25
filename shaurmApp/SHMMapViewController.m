//
//  SHMMapViewController.m
//  shaurmApp
//
//  Created by Igor Nikolaev on 20/03/16.
//  Copyright © 2016 NikolaevIgor. All rights reserved.
//

#import "SHMMapViewController.h"

@interface SHMMapViewController ()

@end

@implementation SHMMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    self.view = [[GMSMapView alloc] initWithFrame:CGRectZero];

}

@end
