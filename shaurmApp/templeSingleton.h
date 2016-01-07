//
//  templeSingleton.h
//  shaurmApp
//
//  Created by Igor Nikolaev on 10.09.15.
//  Copyright (c) 2015 Nikolaev Igor. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreLocation;

@interface templeSingleton : NSObject

@property (strong,nonatomic) NSMutableArray *allTemples;
@property (strong,nonatomic) NSMutableArray *closeTemples;
@property (strong, nonatomic) CLLocation *loc;

+ (templeSingleton *) sharedSingletonManager;

@end
