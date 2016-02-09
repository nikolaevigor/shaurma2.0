//
//  SHMManager.m
//  shaurmApp
//
//  Created by Igor Nikolaev on 09/01/16.
//  Copyright © 2016 NikolaevIgor. All rights reserved.
//

#import "SHMManager.h"

@implementation SHMManager

+ (NSInteger)metersfromPlace:(CLLocationCoordinate2D)from andToPlace:(CLLocationCoordinate2D)to
{
    CLLocation *userloc = [[CLLocation alloc]initWithLatitude:from.latitude longitude:from.longitude];
    CLLocation *dest = [[CLLocation alloc]initWithLatitude:to.latitude longitude:to.longitude];
    
    CLLocationDistance dist = [userloc distanceFromLocation:dest];
    
    NSString *distance = [NSString stringWithFormat:@"%f", dist];
    
    return [distance integerValue];
}

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

#pragma mark - Find temples with threshold

+ (PFObject *)getNearestTempleFor:(CLLocationCoordinate2D)point from:(NSArray *)temples withThreshold:(NSInteger)threshold
{
    PFObject *nearestObject = temples[0];
    PFGeoPoint *nearestGeoPoint = nearestObject[@"location"];
    CLLocationCoordinate2D nearestCoords = CLLocationCoordinate2DMake(nearestGeoPoint.latitude, nearestGeoPoint.longitude);
    
    for (int i = 1; i < temples.count; i++) {
        PFGeoPoint *geoPoint = temples[i][@"location"];
        CLLocationCoordinate2D temporaryCoordinates = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
        if ([self metersfromPlace:point andToPlace:temporaryCoordinates] < [self metersfromPlace:point andToPlace:nearestCoords])
        {
            if ([self metersfromPlace:point andToPlace:temporaryCoordinates] < threshold)
            {
                nearestObject = temples[i];
                nearestGeoPoint = geoPoint;
                nearestCoords = temporaryCoordinates;
            }
        }
    }
    return nearestObject;
}

+ (NSArray *)getNearestTemplesFor:(CLLocationCoordinate2D)point from:(NSArray *)temples numberOfPointsToFind:(NSInteger)number withThreshold:(NSInteger)threshold
{
    NSMutableArray *outputArray = [[NSMutableArray alloc] init];
    NSMutableArray *temples_ = [temples mutableCopy];
    
    for (int i = 0; i < number; i++) {
        PFObject *nearestObject = [self getNearestTempleFor:point from:temples_ withThreshold:threshold];
        [outputArray addObject:nearestObject];
        [temples_ removeObject:nearestObject];
    }
    
    return (NSArray *)outputArray;
}

#pragma mark - Color methods

+ (UIColor *)colorForStation:(NSString *)station
{
    return [self colorFromHexString:[self hexColorOfStation:station]];
}

+ (NSString *)hexColorOfStation:(NSString *)station
{
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *path = [mainBundle pathForResource: @"metroJSON" ofType: @"json"];
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
    
    NSArray* json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    for (int i = 0; i < json.count; i++)
    {
        NSDictionary *line = json[i];
        NSString *colorInHex = [line allKeys][0];
        NSArray *stations = [line allValues][0];
        for (int i = 0; i < stations.count; i++) {
            if ([stations[i] isEqual:station]) {
                return colorInHex;
            }
        }
    }
    return nil;
}

+ (UIColor *)colorFromHexString:(NSString *)hexString {
    if (!hexString) {
        return [UIColor greenColor];
    }
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
