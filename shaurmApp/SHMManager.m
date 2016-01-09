//
//  SHMManager.m
//  shaurmApp
//
//  Created by Igor Nikolaev on 09/01/16.
//  Copyright © 2016 NikolaevIgor. All rights reserved.
//

#import "SHMManager.h"

@implementation SHMManager

+ (PFObject *)getNearestTempleFor:(CLLocationCoordinate2D)point from:(NSArray *)temples
{
    PFObject *nearestObject = temples[0];
    PFGeoPoint *nearestGeoPoint = nearestObject[@"location"];
    CLLocationCoordinate2D nearestCoords = CLLocationCoordinate2DMake(nearestGeoPoint.latitude, nearestGeoPoint.longitude);
    
    for (int i = 1; i < temples.count; i++) {
        PFGeoPoint *geoPoint = temples[i][@"location"];
        CLLocationCoordinate2D temporaryCoordinates = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
        if ([self metersfromPlace:point andToPlace:temporaryCoordinates] < [self metersfromPlace:point andToPlace:nearestCoords]) {
            nearestObject = temples[i];
            nearestGeoPoint = geoPoint;
            nearestCoords = temporaryCoordinates;
        }
    }
    return nearestObject;
}

+ (NSArray *)getNearestTemplesFor:(CLLocationCoordinate2D)point from:(NSArray *)temples numberOfPointsToFind:(NSInteger)number
{
    NSMutableArray *outputArray = [[NSMutableArray alloc] init];
    NSMutableArray *temples_ = [temples mutableCopy];
    
    for (int i = 0; i < number; i++) {
        PFObject *nearestObject = [self getNearestTempleFor:point from:temples_];
        [outputArray addObject:nearestObject];
        [temples_ removeObject:nearestObject];
    }
    
    return (NSArray *)outputArray;
}

+ (NSInteger)metersfromPlace:(CLLocationCoordinate2D)from andToPlace:(CLLocationCoordinate2D)to
{
    CLLocation *userloc = [[CLLocation alloc]initWithLatitude:from.latitude longitude:from.longitude];
    CLLocation *dest = [[CLLocation alloc]initWithLatitude:to.latitude longitude:to.longitude];
    
    CLLocationDistance dist = [userloc distanceFromLocation:dest];
    
    NSString *distance = [NSString stringWithFormat:@"%f", dist];
    
    return [distance integerValue];
}

@end
