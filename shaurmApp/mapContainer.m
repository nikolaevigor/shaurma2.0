//
//  mapContainer.m
//  shaurmApp
//
//  Created by Igor Nikolaev on 07.09.15.
//  Copyright (c) 2015 Nikolaev Igor. All rights reserved.
//

#import "mapContainer.h"

@interface mapContainer ()
{
    PPRevealSideViewController *container;
    mapVC *map;
    sliderVC *slider;
}

@end

@implementation mapContainer

- (void)viewDidLoad
{
    map = [[mapVC alloc] init];
    slider = [[sliderVC alloc] init];
    container = [[PPRevealSideViewController alloc] initWithRootViewController:slider];
    [container setOption:PPRevealSideOptionsiOS7StatusBarMoving];
    //container.options = PPRevealSideOptionsShowShadows << 1;
    [container pushViewController:map onDirection:PPRevealSideDirectionTop withOffset:80 animated:NO];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(sliderSwiped:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [slider.view addGestureRecognizer:swipeDown];
    
    [self.view addSubview:container.view];
    
    [super viewDidLoad];
}

- (void)sliderSwiped:(UISwipeGestureRecognizer *)swipe
{
    [container pushViewController:map onDirection:PPRevealSideDirectionTop withOffset:80 animated:YES];
}

/*/snippet to make navBar invisible in map and visible in templeVC
- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}
//snippet ends here*/

@end
