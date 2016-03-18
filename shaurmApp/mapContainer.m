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

@property (strong, nonatomic) mapVC *map;
@property (strong, nonatomic) sliderVC *slider;
@property (strong, nonatomic) newTempleVC *openedTemple;
@property (weak, nonatomic) id <mapDelegate> delegateMap;
@property (weak, nonatomic) id <sliderDelegate> delegateSlider;
@property (strong, nonatomic) PPRevealSideViewController *container;

@end

@implementation mapContainer

- (void)viewDidLoad
{
    self.map = [[mapVC alloc] init];
    self.slider = [[sliderVC alloc] init];
    self.container = [[PPRevealSideViewController alloc] initWithRootViewController:self.slider];
    
    self.delegateMap = self.map;
    self.delegateSlider = self.slider;
    [(sliderVC *)self.delegateSlider setContainerDelegate:self];
    
    [self.container setOption:PPRevealSideOptionsiOS7StatusBarMoving];
    [self.container pushViewController:self.map onDirection:PPRevealSideDirectionTop withOffset:90 animated:NO];
    self.slider.view.userInteractionEnabled = NO;
    
    self.container.options = PPRevealSideOptionsShowShadows << 1; //shadows: off
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(pop)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self.slider.view addGestureRecognizer:swipeDown];
    
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showSlider)];
    swipeDown.direction = UISwipeGestureRecognizerDirectionUp;
    [self.slider.view addGestureRecognizer:swipeUp];
    
    [self.view addSubview:self.container.view];
    
    [super viewDidLoad];
}

- (void)setSliderInteractions:(BOOL)isAvailable
{
    [self.delegateSlider setUserInteractions:isAvailable];
}

- (void)sliderSwiped:(UISwipeGestureRecognizer *)swipe
{
    [self.delegateSlider setTableViewWith:[self.delegateMap getNearest]]; //refresh table on swipe
    [self.container pushViewController:self.map onDirection:PPRevealSideDirectionTop withOffset:90 animated:YES];
}

#pragma mark - containerDelegate methods

- (void)pop
{
    if (self.map.isDownloaded) {
        [self.delegateSlider setTableViewWith:[self.delegateMap getNearest]]; //refresh table on swipe
        [self.container pushViewController:self.map onDirection:PPRevealSideDirectionTop withOffset:90 animated:YES];
    }
}

- (void)refreshSlider
{
    if (self.map.isDownloaded) {
        [self.delegateSlider setTableViewWith:[self.delegateMap getNearest]];
    }
}

- (void)showSlider
{
    if (self.map.isDownloaded)
    {
        [self.delegateSlider setTableViewWith:[self.delegateMap getNearest]];
        [self.container popViewControllerAnimated:YES completion:nil];
    }
}

- (void)openTempleVC:(NSString *)id_
{
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

@end
