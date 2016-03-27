//
//  SHMManager.h
//  shaurmApp
//
//  Created by Igor Nikolaev on 09/01/16.
//  Copyright © 2016 NikolaevIgor. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;
#import "Parse.h"
#import "SHMTemple.h"

@interface SHMManager : NSObject

+ (SHMTemple *)getNearestTempleFor:(CLLocationCoordinate2D)point from:(NSArray *)temples;
+ (NSArray *)getNearestTemplesFor:(CLLocationCoordinate2D)point from:(NSArray *)temples numberOfPointsToFind:(NSInteger)number;
+ (UIColor *)colorForStation:(NSString *)station;
+ (BOOL)isStation:(NSString *)station;

@end
