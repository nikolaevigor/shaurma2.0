//
//  SHMMapViewController.m
//  shaurmApp
//
//  Created by Igor Nikolaev on 20/03/16.
//  Copyright © 2016 NikolaevIgor. All rights reserved.
//

#import "SHMMapViewController.h"
#import "SHMMapDelegate.h"
#import "SMCalloutView.h"

@interface SHMMapViewController () <GMSMapViewDelegate>

@property (weak, nonatomic) id <SHMMapDelegate> delegate;

@property (strong, nonatomic) SMCalloutView *calloutView;
@property (strong, nonatomic) UIView *emptyCalloutView;

@end

@implementation SHMMapViewController
{
    BOOL firstLocationUpdate;
}

- (instancetype)initWithDelegate:(id)delegate
{
    if (self = [super init]) {
        self.delegate = delegate;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    GMSMapView *mapView = [[GMSMapView alloc] initWithFrame:self.view.frame];
    mapView.settings.compassButton = YES;
    mapView.settings.myLocationButton = YES;
    mapView.myLocationEnabled = YES;
    mapView.padding = UIEdgeInsetsMake(60.0, 0.0, 113.0, 0.0); //first: impacts on compass; second: impacts on location button
    mapView.delegate = self;
    [mapView addObserver:self forKeyPath:@"myLocation" options:NSKeyValueObservingOptionNew context: NULL];
    dispatch_async(dispatch_get_main_queue(), ^{
        mapView.myLocationEnabled = YES;
    });
    
    self.view = mapView;
    
    self.emptyCalloutView = [[UIView alloc] initWithFrame:CGRectZero];
    self.calloutView = [[SMCalloutView alloc] init];
    self.calloutView.hidden = YES;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [button setImage:[UIImage imageNamed:@"callout2"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(calloutAccessoryButtonTapped:)
     forControlEvents:UIControlEventTouchUpInside];
    self.calloutView.rightAccessoryView = button;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)setPinsForTemples:(NSArray *)temples
{
    NSArray *customIconsArray =  @[
                                   [self image:[UIImage imageNamed:@"pin0"] scaledToSize:CGSizeMake(30.0f, 60.0f)],
                                   [self image:[UIImage imageNamed:@"pin1"] scaledToSize:CGSizeMake(30.0f, 60.0f)],
                                   [self image:[UIImage imageNamed:@"pin2"] scaledToSize:CGSizeMake(30.0f, 60.0f)],
                                   [self image:[UIImage imageNamed:@"pin3"] scaledToSize:CGSizeMake(30.0f, 60.0f)],
                                   [self image:[UIImage imageNamed:@"pin4"] scaledToSize:CGSizeMake(30.0f, 60.0f)],
                                   [self image:[UIImage imageNamed:@"pin5"] scaledToSize:CGSizeMake(30.0f, 60.0f)],
                                   [self image:[UIImage imageNamed:@"pin6"] scaledToSize:CGSizeMake(30.0f, 60.0f)],
                                   [self image:[UIImage imageNamed:@"pin7"] scaledToSize:CGSizeMake(30.0f, 60.0f)],
                                   [self image:[UIImage imageNamed:@"pin8"] scaledToSize:CGSizeMake(30.0f, 60.0f)],
                                   [self image:[UIImage imageNamed:@"pin9"] scaledToSize:CGSizeMake(30.0f, 60.0f)],
                                   [self image:[UIImage imageNamed:@"pin10"] scaledToSize:CGSizeMake(30.0f, 60.0f)],
                                   ];
    
    for (int i = 0; i < temples.count; i++)
    {
        GMSMarker *mark = [[GMSMarker alloc] init];
        SHMTemple *currentTemple = temples[i];
        
        mark.position = CLLocationCoordinate2DMake([(SHMTemple *)temples[i] latitude], [(SHMTemple *)temples[i] longitude]);
        mark.map = (GMSMapView *)self.view;
        mark.title = [currentTemple title];
        mark.snippet = [NSString stringWithFormat:@"%lu/10", (unsigned long)[currentTemple rating]];
        mark.icon = customIconsArray[(unsigned long)[currentTemple rating]];
        mark.userData = [currentTemple templeID];
    }
}

- (void)setPinForTemple:(SHMTemple *)temple
{
    firstLocationUpdate = YES;
    
    GMSMarker *mark = [[GMSMarker alloc] init];
    
    mark.position = CLLocationCoordinate2DMake([temple latitude], [temple longitude]);
    mark.map = (GMSMapView *)self.view;
    mark.title = [temple title];
    mark.snippet = [NSString stringWithFormat:@"%lu/10", (unsigned long)[temple rating]];
    mark.icon = [self image:[UIImage imageNamed:[NSString stringWithFormat:@"pin%lu", (unsigned long)[temple rating]]] scaledToSize:CGSizeMake(30.0f, 60.0f)];
    mark.userData = [temple templeID];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:temple.latitude longitude:temple.longitude zoom:13];
    [(GMSMapView *)self.view setCamera:camera];
    //[(GMSMapView *)self.view setSelectedMarker:mark];
}

#pragma mark - Callout window methods

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    CLLocationCoordinate2D anchor = marker.position;
    
    CGPoint point = [mapView.projection pointForCoordinate:anchor];
    
    self.calloutView.title = marker.title;
    self.calloutView.subtitle = marker.snippet;
    self.calloutView.calloutOffset = CGPointMake(0, -10.0f);
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

- (void)mapView:(GMSMapView *)pMapView didChangeCameraPosition:(GMSCameraPosition *)position
{
    /* move callout with map drag */
    if (pMapView.selectedMarker != nil && !self.calloutView.hidden) {
        CLLocationCoordinate2D anchor = [pMapView.selectedMarker position];
        
        CGPoint arrowPt = self.calloutView.backgroundView.arrowPoint;
        
        CGPoint pt = [pMapView.projection pointForCoordinate:anchor];
        pt.x -= arrowPt.x;
        pt.y -= arrowPt.y + 10.0f;
        
        self.calloutView.frame = (CGRect) {.origin = pt, .size = self.calloutView.frame.size };
    } else {
        self.calloutView.hidden = YES;
    }
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    self.calloutView.hidden = YES;
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    /* don't move map camera to center marker on tap */
    mapView.selectedMarker = marker;
    return YES;
}

- (void)calloutAccessoryButtonTapped:(id)sender
{
//    if (self.openedFromTemple) {
//        return;
//    }
//    if (mapView_.selectedMarker)
//    {
//        [self.containerDelegate openTempleVC:(NSString *)mapView_.selectedMarker.userData];
//    }
}

#pragma mark - KVO update methods

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    CLLocationCoordinate2D coordinates = [(GMSMapView *)self.view myLocation].coordinate;
    [self.delegate setCurrentLocationWithLatitude:coordinates.latitude Longitude:coordinates.longitude];
    if (!firstLocationUpdate) {
        // If the first location update has not yet been recieved, then jump to that
        // location.
        firstLocationUpdate = YES;
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        //mapView_.camera = [GMSCameraPosition cameraWithTarget:location.coordinate
        //                                                 zoom:14];
        
        [(GMSMapView *)self.view setCamera:[GMSCameraPosition cameraWithTarget:location.coordinate
                                                           zoom:14]];
        
    }
}

- (void)dealloc
{
    [self.view removeObserver:self forKeyPath:@"myLocation" context:NULL];
}

#pragma mark - Nice snippets

//method for resizing image
- (UIImage *)image:(UIImage*)originalImage scaledToSize:(CGSize)size
{
    if (CGSizeEqualToSize(originalImage.size, size))
    {
        return originalImage;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
