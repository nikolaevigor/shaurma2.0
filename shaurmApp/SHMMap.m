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
#import "SHMDownloader.h"
#import "SHMManager.h"
#import "shaurmApp-Swift.h"

@interface SHMMap () <SHMMapDelegate>

@property (strong, nonatomic) SHMSliderViewController *slider;
@property (strong, nonatomic) SHMMapViewController *map;

@property NSArray *temples;
@property CLLocationCoordinate2D locationCoordinate;
@property newTempleVC *openedTemple;

@end

@implementation SHMMap

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.map = [[SHMMapViewController alloc] initWithDelegate:self];
        self.slider = [[SHMSliderViewController alloc] initWithDelegate:self];
        
        [GMSServices provideAPIKey:@"AIzaSyDKgrM3pG0lO2a9r9dxA-srnsEgCuWsJWs"];
        
        self = [super initWithRootViewController:self.slider];
    }
    
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return NO;
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
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault]; // prevent tab bar to disappear after returning from newTempleVC
    
    if (!self.temples) {
        [self pushViewController:self.map onDirection:PPRevealSideDirectionTop withOffset:113 animated:NO];
        [self downloadTemples];
    }
}

- (void)showSlider
{
    [self popViewControllerAnimated:YES completion:nil];
}

- (void)showMap
{
    [self pushViewController:self.map onDirection:PPRevealSideDirectionTop withOffset:113 animated:YES];
}

- (void)setCurrentLocationWithLatitude:(float)latitude Longitude:(float)longitude
{
    self.locationCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    if (self.temples) {
        [self.slider setTableWithTemples:[SHMManager getNearestTemplesFor:self.locationCoordinate from:self.temples numberOfPointsToFind:10]];
    }
}

- (void)downloadTemples
{
    ShawarmaSpinnerView *spinner = [[ShawarmaSpinnerView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [self.view addSubview:spinner];
    [spinner start];
    [SHMDownloader getTemplesInBackgroundWithBlock:^void (NSArray *temples){
        self.temples = temples;
        [self.map setPinsForTemples:temples];
        if (self.locationCoordinate.latitude != 0 && self.locationCoordinate.longitude != 0) {
            [self.slider setTableWithTemples:[SHMManager getNearestTemplesFor:self.locationCoordinate from:temples numberOfPointsToFind:10]];
        }
        [spinner setHidden:YES];
        [spinner stop];
    }];
}

- (void)openTempleViewControllerWithID:(NSString *)templeID
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.openedTemple = [storyBoard instantiateViewControllerWithIdentifier:@"newTempleVC"];
    self.openedTemple.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self.openedTemple setId:templeID];
    [self.navigationController pushViewController:self.openedTemple animated:YES];
}

@end
