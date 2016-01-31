//
//  mapContainer.m
//  shaurmApp
//
//  Created by Igor Nikolaev on 07.09.15.
//  Copyright (c) 2015 Nikolaev Igor. All rights reserved.
//

#import "mapContainer.h"
#import "mapDelegate.h"
#import "sliderDelegate.h"
#import "shaurmApp-Swift.h"

@interface mapContainer ()

@property (strong, nonatomic) PPRevealSideViewController *container;
@property (strong, nonatomic) mapVC *map;
@property (strong, nonatomic) sliderVC *slider;
@property (strong, nonatomic) newTempleVC *openedTemple;
@property (weak, nonatomic) id <mapDelegate> delegateMap;
@property (weak, nonatomic) id <sliderDelegate> delegateSlider;

@end

@implementation mapContainer

- (void)viewDidLoad
{
    self.map = [[mapVC alloc] init];
    self.slider = [[sliderVC alloc] init];
    self.container = [[PPRevealSideViewController alloc] initWithRootViewController:self.slider];
    
    self.delegateMap = self.map;
    self.delegateSlider = self.slider;
    
    [self.container setOption:PPRevealSideOptionsiOS7StatusBarMoving];
    [self.container pushViewController:self.map onDirection:PPRevealSideDirectionTop withOffset:80 animated:NO];
    self.container.options = PPRevealSideOptionsShowShadows << 1; //shadows: off
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(sliderSwiped:)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.slider.view addGestureRecognizer:swipeDown];
    
    [self.view addSubview:self.container.view];
    
    [super viewDidLoad];
}

- (void)sliderSwiped:(UISwipeGestureRecognizer *)swipe
{
    [self.delegateSlider setTableViewWith:[self.delegateMap getNearest]]; //refresh table on swipe
    [self.container pushViewController:self.map onDirection:PPRevealSideDirectionTop withOffset:80 animated:YES];
}

#pragma mark - containerDelegate methods

- (void)templesIsDownloaded
{
    [self.delegateSlider setTableViewWith:[self.delegateMap getNearest]];
}

- (void)refreshSlider
{
    [self.delegateSlider setTableViewWith:[self.delegateMap getNearest]];
}



- (void)openTempleVC:(NSString *)id_
{
    
//    self.openedTemple = [[newTempleVC alloc] init];
//    [self.openedTemple setId:id_];
//    [self.navigationController pushViewController:self.openedTemple animated:YES];
    
    
    //ALTERNATIVE IMPLEMENTATION
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.openedTemple = [storyBoard instantiateViewControllerWithIdentifier:@"newTempleVC"];
    self.openedTemple.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.openedTemple setId:id_];
    [self.navigationController pushViewController:self.openedTemple animated:YES];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault]; // prevent tab bar to disappear after returning from newTempleVC
    [super viewWillAppear:animated];
}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [self.navigationController setNavigationBarHidden:NO animated:animated];
//    [super viewWillDisappear:animated];
//}


@end
