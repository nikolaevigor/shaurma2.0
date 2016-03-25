//
//  SHMMapViewController.m
//  shaurmApp
//
//  Created by Igor Nikolaev on 20/03/16.
//  Copyright © 2016 NikolaevIgor. All rights reserved.
//

#import "SHMMapViewController.h"
#import "SHMMapDelegate.h"

@interface SHMMapViewController ()

@property (weak, nonatomic) id <SHMMapDelegate> delegate;

@end

@implementation SHMMapViewController

- (instancetype)initWithDelegate:(id)delegate
{
    if (self = [super init]) {
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = [[GMSMapView alloc] initWithFrame:CGRectZero];
}

@end
