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
#import "SHMMapDelegate.h"

@interface SHMMap () <SHMMapDelegate>

@property (strong, nonatomic) SHMSliderViewController *slider;
@property (strong, nonatomic) SHMMapViewController *map;

@end

@implementation SHMMap

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self.map = [[SHMMapViewController alloc] initWithDelegate:self];
    self.slider = [[SHMSliderViewController alloc] initWithDelegate:self];
    
    [GMSServices provideAPIKey:@"AIzaSyDKgrM3pG0lO2a9r9dxA-srnsEgCuWsJWs"];
    
    self = [super initWithRootViewController:self.slider];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UISwipeGestureRecognizer *sliderSwipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showMap)];
    sliderSwipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.slider.view addGestureRecognizer:sliderSwipeDown];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self pushViewController:self.map onDirection:PPRevealSideDirectionTop withOffset:113 animated:NO];
}

- (void)showSlider
{
    [self popViewControllerAnimated:YES completion:nil];
}

- (void)showMap
{
    [self pushViewController:self.map onDirection:PPRevealSideDirectionTop withOffset:113 animated:YES];
}

@end
