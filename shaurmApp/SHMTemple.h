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
@property (nonnull, strong, nonatomic) NSString *subway;
@property (nullable, strong, nonatomic) NSArray *photos;
@property (nullable, strong, nonatomic) NSDictionary *menu;
@property (nullable, strong, nonatomic) NSArray *reviews;
@property (nonnull, strong, nonatomic) NSString *templeID;
@property NSUInteger lowestPrice;
@property NSUInteger rating;
@property BOOL cap;
@property BOOL gloves;
@property float latitude;
@property float longitude;

// Prohibited
- (nonnull instancetype)init __unavailable;
+ (nonnull instancetype)new __unavailable;

// designated initializer
- (nonnull instancetype)initWithTitle:(nonnull NSString *)title
                               Subway:(nonnull NSString *)subway
                               Photos:(nullable NSArray *)photos
                                 Menu:(nullable NSDictionary *)menu
                              Reviews:(nullable NSArray *)reviews
                             TempleID:(nonnull NSString *)templeID
                          LowestPrice:(NSUInteger)lowestPrice
                               Rating:(NSUInteger)rating
                                  Cap:(BOOL)cap
                               Gloves:(BOOL)gloves
                             Latitude:(float)latitude
                           Longitude:(float)longitude;

- (nonnull instancetype)initWithTitle:(nonnull NSString *)title
                               Subway:(nonnull NSString *)subway
                             TempleID:(nonnull NSString *)templeID
                             Latitude:(float)latitude
                            Longitude:(float)longitude;



@end
