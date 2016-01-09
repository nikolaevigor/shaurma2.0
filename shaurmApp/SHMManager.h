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

@interface SHMManager : NSObject

+ (PFObject *)getNearestTempleFor:(CLLocationCoordinate2D)point from:(NSArray *)temples;
+ (NSArray *)getNearestTemplesFor:(CLLocationCoordinate2D)point from:(NSArray *)temples numberOfPointsToFind:(NSInteger)number;

@end
