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

static const CGFloat CalloutYOffset = 10.0f;

@interface mapVC ()

@property (strong, nonatomic) SMCalloutView *calloutView;
@property (strong, nonatomic) UIView *emptyCalloutView;

@property (strong, nonatomic) NSArray *temples;

@end

@implementation mapVC
{
    GMSMapView *mapView_;
    BOOL firstLocationUpdate_;
    UIView *popUpWindow;
}

- (void)viewDidLoad {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:55.75309756657614
                                                            longitude:37.62137420204017
                                                                 zoom:0];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.settings.compassButton = YES;
    mapView_.padding = UIEdgeInsetsMake(5, 0, 0, 0);//move compass
    mapView_.delegate = self;
    [mapView_ addObserver:self
               forKeyPath:@"myLocation"
                  options:NSKeyValueObservingOptionNew
                  context:NULL];
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
    
    [SHMDownloader getTemplesInBackgroundWithBlock:^void (NSArray * temples_) {
            self.temples = temples_;
            UIImage *customIcon = [UIImage imageNamed:@"pin3"];
            for (int i = 0; i < self.temples.count; i++)
                {
                    GMSMarker *mrk = [[GMSMarker alloc] init];
                    PFGeoPoint *gPoint = self.temples[i][@"location"];
                    mrk.position = CLLocationCoordinate2DMake(gPoint.latitude, gPoint.longitude);
                    mrk.map = mapView_;
                    mrk.title = self.temples[i][@"title"];
                    mrk.snippet = self.temples[i][@"rate"];
                    mrk.icon = [self image:customIcon scaledToSize:CGSizeMake(30.0f, 60.0f)];
                    mrk.userData = [self.temples[i] objectId];
                }
    }];
    
    [super viewDidLoad];
};

#pragma mark - KVO update methods

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
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
    [mapView_ removeObserver:self
                  forKeyPath:@"myLocation"
                     context:NULL];
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
        
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        
        newTempleVC *wnd = (newTempleVC *)[mainStoryboard instantiateViewControllerWithIdentifier: @"newTempleVC"];
        
        [self presentViewController:wnd animated:YES completion:^{wnd.id = (NSString *)mapView_.selectedMarker.userData;}];
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

@end
