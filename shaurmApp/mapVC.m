//
//  SecondViewController.m
//  shaurmApp
//
//  Created by Igor Nikolaev on 27/08/15.
//  Copyright (c) 2015 Nikolaev Igor. All rights reserved.
//

#import "mapVC.h"
#import "shaurmApp-Swift.h"
#import "PFObject.h"
#import "PFGeoPoint.h"

static const CGFloat CalloutYOffset = 10.0f;

@interface mapVC ()
@property (strong, nonatomic) SMCalloutView *calloutView;
@property (strong, nonatomic) UIView *emptyCalloutView;
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
    
    templeSingleton *singleton = [[templeSingleton alloc] init];
    UIImage *customIcon = [UIImage imageNamed:@"pin2.png"];
    for (int i; i < singleton.allTemples.count; i++)
    {
        GMSMarker *mrk = [[GMSMarker alloc] init];
        PFGeoPoint *gPoint = singleton.allTemples[i][@"location"];
        mrk.position = CLLocationCoordinate2DMake(gPoint.latitude, gPoint.longitude);
        mrk.map = mapView_;
        mrk.title = singleton.allTemples[i][@"title"];
        mrk.snippet = singleton.allTemples[i][@"rate"];
        mrk.icon = customIcon;
        mrk.icon = [self image:mrk.icon scaledToSize:CGSizeMake(20.0f, 40.0f)];
        mrk.userData = [singleton.allTemples[i] objectId];
    }
    
    singleton.loc = mapView_.myLocation;
    
    self.calloutView = [[SMCalloutView alloc] init];
    self.calloutView.hidden = YES;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [button addTarget:self
               action:@selector(calloutAccessoryButtonTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    self.calloutView.rightAccessoryView = button;
    
    self.emptyCalloutView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [super viewDidLoad];
};

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
        newTempleVC *wnd = [self.storyboard instantiateViewControllerWithIdentifier:@"templeWindow"];
        [self prepareForSegue:[UIStoryboardSegue segueWithIdentifier:@"mapToTemple"
                                                              source:self
                                                         destination:wnd
                                                      performHandler:^{wnd.id = (NSString *)mapView_.selectedMarker.userData;}]
                       sender:sender];
        [self performSegueWithIdentifier:@"mapToTemple" sender:sender];
    }
}

- (void)closePopUpWindow
{
    [popUpWindow removeFromSuperview];
}

//overriding prepare segue to make him work with our storyboard id

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqual: @"mapToTemple"])
    {
        newTempleVC *wnd = (newTempleVC *)segue.destinationViewController;
        wnd.id = (NSString *)mapView_.selectedMarker.userData;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}




@end
