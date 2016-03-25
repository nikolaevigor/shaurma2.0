//
//  SHMTemple.h
//  shaurmApp
//
//  Created by Igor Nikolaev on 25/03/16.
//  Copyright © 2016 NikolaevIgor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHMTemple : NSObject

@property (nonnull, strong, nonatomic) NSString *title;
@property (nullable, strong, nonatomic) NSArray *photos;
@property (nullable, strong, nonatomic) NSDictionary *menu;
@property (nullable, strong, nonatomic) NSArray *reviews;
@property NSUInteger rating;
@property BOOL cap;
@property BOOL gloves;
@property float latitude;
@property float longtitude;

// Prohibited
- (nonnull instancetype)init __unavailable;
+ (nonnull instancetype)new __unavailable;

// designated initializer
- (nonnull instancetype)initWithTitle:(nonnull NSString *)title latitude:(float)latitude longtitude:(float)longtitude;



@end
