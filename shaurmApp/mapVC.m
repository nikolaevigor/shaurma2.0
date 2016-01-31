//
//  SecondViewController.m
//  shaurmApp
//
//  Created by Igor Nikolaev on 27/08/15.
//  Copyright (c) 2015 Nikolaev Igor. All rights reserved.
//

#import "mapVC.h"
#import "shaurmApp-Swift.h"
#import "Parse.h"
#import "SHMDownloader.h"
#import "containerDelegate.h"
#import "mapContainer.h"
#import "SHMManager.h"

static const CGFloat CalloutYOffset = 10.0f;

@interface mapVC ()

@property (strong, nonatomic) SMCalloutView *calloutView;
@property (strong, nonatomic) UIView *emptyCalloutView;
@property (strong, nonatomic) NSArray *temples;

@property (weak, nonatomic) id <containerDelegate> containerDelegate;

@end

@implementation mapVC
{
    GMSMapView *mapView_;
    BOOL firstLocationUpdate_;
    UIView *popUpWindow;
}

- (void)viewDidLoad {
    UITabBarController *mainTabBar = (UITabBarController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    UINavigationController *localNavController = (UINavigationController *)[mainTabBar viewControllers][1];
    mapContainer *container = [localNavController viewControllers][0];
    self.containerDelegate = container;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:55.75309756657614 longitude:37.62137420204017 zoom:0];
    
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.settings.compassButton = YES;
    mapView_.settings.myLocationButton = YES;
    mapView_.myLocationEnabled = YES;
    mapView_.padding = UIEdgeInsetsMake(60.0, 0.0, 90.0, 0.0); //first: impacts on compass; second: impacts on location button
    mapView_.delegate = self;
    
    [mapView_ addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context: NULL];
    
    self.view = mapView_;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView_.myLocationEnabled = YES;
    });
    
    
    self.calloutView = [[SMCalloutView alloc] init];
    self.calloutView.hidden = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [button addTarget:self
               action:@selector(calloutAccessoryButtonTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    self.calloutView.rightAccessoryView = button;
    
    self.emptyCalloutView = [[UIView alloc] initWithFrame:CGRectZero];
    
    NSArray *customIconsArray = @[
                                  [UIImage imageNamed:@"pin0"],
                                  [UIImage imageNamed:@"pin1"],
                                  [UIImage imageNamed:@"pin2"],
                                  [UIImage imageNamed:@"pin3"],
                                  [UIImage imageNamed:@"pin4"],
                                  [UIImage imageNamed:@"pin5"],
                                  [UIImage imageNamed:@"pin6"],
                                  [UIImage imageNamed:@"pin7"],
                                  [UIImage imageNamed:@"pin8"],
                                  [UIImage imageNamed:@"pin9"],
                                  [UIImage imageNamed:@"pin10"],
                                  ];
    
    [SHMDownloader getTemplesInBackgroundWithBlock:^void (NSArray * temples_) {
        self.temples = temples_;
        
        [self.containerDelegate templesIsDownloaded];
        
        for (int i = 0; i < self.temples.count; i++)
        {
            GMSMarker *mark = [[GMSMarker alloc] init];
            PFGeoPoint *geoPoint = self.temples[i][@"location"];
            NSInteger ratingNumber = [self.temples[i][@"ratingNumber"] integerValue];
            
            mark.position = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
            mark.map = mapView_;
            mark.title = self.temples[i][@"title"];
            mark.snippet = self.temples[i][@"ratingString"];
            mark.icon = [self image:customIconsArray[ratingNumber] scaledToSize:CGSizeMake(30.0f, 60.0f)];
            mark.userData = [self.temples[i] objectId];
        }
    }];
    
    [super viewDidLoad];
};

#pragma mark - KVO update methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (!firstLocationUpdate_) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        firstLocationUpdate_ = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                         zoom:14];
    }
}

- (void)dealloc {
    [mapView_ removeObserver:self forKeyPath:@"myLocation" context:NULL];
}

#pragma mark - Callout window methods

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {
    CLLocationCoordinate2D anchor = marker.position;
    
    CGPoint point = [mapView.projection pointForCoordinate:anchor];
    
    self.calloutView.title = marker.title;
    self.calloutView.subtitle = marker.snippet;
    self.calloutView.calloutOffset = CGPointMake(0, -CalloutYOffset);
    self.calloutView.hidden = NO;
    
    CGRect calloutRect = CGRectZero;
    calloutRect.origin = point;
    calloutRect.size = CGSizeZero;
    
    [self.calloutView presentCalloutFromRect:calloutRect
                                      inView:mapView
                           constrainedToView:mapView
                                    animated:YES];
    
    return self.emptyCalloutView;
}

- (void)mapView:(GMSMapView *)pMapView didChangeCameraPosition:(GMSCameraPosition *)position {
    /* move callout with map drag */
    if (pMapView.selectedMarker != nil && !self.calloutView.hidden) {
        CLLocationCoordinate2D anchor = [pMapView.selectedMarker position];
        
        CGPoint arrowPt = self.calloutView.backgroundView.arrowPoint;
        
        CGPoint pt = [pMapView.projection pointForCoordinate:anchor];
        pt.x -= arrowPt.x;
        pt.y -= arrowPt.y + CalloutYOffset;
        
        self.calloutView.frame = (CGRect) {.origin = pt, .size = self.calloutView.frame.size };
    } else {
        self.calloutView.hidden = YES;
    }
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    self.calloutView.hidden = YES;
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    /* don't move map camera to center marker on tap */
    mapView.selectedMarker = marker;
    return YES;
    
}

- (void)calloutAccessoryButtonTapped:(id)sender {
    if (mapView_.selectedMarker)
    {
        [self.containerDelegate openTempleVC:(NSString *)mapView_.selectedMarker.userData];
    }
}

- (void)closePopUpWindow
{
    [popUpWindow removeFromSuperview];
}

#pragma mark - Nice snippets

//method for resizing image
- (UIImage *)image:(UIImage*)originalImage scaledToSize:(CGSize)size
{
    //avoid redundant drawing
    if (CGSizeEqualToSize(originalImage.size, size))
    {
        return originalImage;
    }
    
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    //draw
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}

#pragma mark - mapDelegate methods

- (NSArray *)getNearest
{
    return [SHMManager getNearestTemplesFor:mapView_.myLocation.coordinate from:self.temples numberOfPointsToFind:7];
}

@end
