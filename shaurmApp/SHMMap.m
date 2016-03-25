//
//  SHMMap.m
//  shaurmApp
//
//  Created by Igor Nikolaev on 20/03/16.
//  Copyright © 2016 NikolaevIgor. All rights reserved.
//

#import "SHMMap.h"
#import "SHMMapViewController.h"
#import "SHMSliderViewController.h"

@interface SHMMap ()

@property (strong, nonatomic) SHMSliderViewController *slider;
@property (strong, nonatomic) SHMMapViewController *map;

@end

@implementation SHMMap

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self.map = [[SHMMapViewController alloc] init];
    self.slider = [[SHMSliderViewController alloc] init];
    
    [GMSServices provideAPIKey:@"AIzaSyDKgrM3pG0lO2a9r9dxA-srnsEgCuWsJWs"];
    
    self = [super initWithRootViewController:self.slider];
    
    [self pushViewController:self.map onDirection:PPRevealSideDirectionTop withOffset:90.f animated:YES];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *sliderSwipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(sliderSwipedDown)];
    sliderSwipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.slider.view addGestureRecognizer:sliderSwipeDown];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)sliderSwipedDown
{
    [self pushViewController:self.map onDirection:PPRevealSideDirectionTop withOffset:90.0f animated:YES];
}

@end
