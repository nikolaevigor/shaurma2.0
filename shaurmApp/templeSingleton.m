//
//  templeSingleton.m
//  shaurmApp
//
//  Created by Igor Nikolaev on 10.09.15.
//  Copyright (c) 2015 Nikolaev Igor. All rights reserved.
//

#import "templeSingleton.h"

@implementation templeSingleton



#pragma mark - Singleton

static templeSingleton *sharedSingletonManager = nil;

+ (templeSingleton *) sharedSingletonManager
{
    if(!sharedSingletonManager)
    {
        sharedSingletonManager = [[super allocWithZone:NULL] init];
    }
    return sharedSingletonManager;
}

+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedSingletonManager];
}

- (id) init
{
    if (sharedSingletonManager)
        return sharedSingletonManager;
    
    self = [super init];
    
    return self;
}


@end
