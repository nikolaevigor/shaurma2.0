//
//  SHMTemple.m
//  shaurmApp
//
//  Created by Igor Nikolaev on 25/03/16.
//  Copyright © 2016 NikolaevIgor. All rights reserved.
//

#import "SHMTemple.h"

@implementation SHMTemple

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
                           Longtitude:(float)longitude
{
    if (self = [super init]) {
        _title = [title copy];
        _subway = [subway copy];
        _templeID = [templeID copy];
        if (photos) {
            _photos = photos;
        }
        if (menu) {
            _menu = menu;
        }
        if (reviews) {
            _reviews = reviews;
        }
        _lowestPrice = lowestPrice;
        _rating = rating;
        _cap = cap;
        _gloves = gloves;
        _latitude = latitude;
        _longitude = longitude;
    }
    return self;
}

- (nonnull instancetype)initWithTitle:(nonnull NSString *)title
                               Subway:(nonnull NSString *)subway
                             TempleID:(nonnull NSString *)templeID
                             Latitude:(float)latitude
                            Longitude:(float)longitude
{
    return [self initWithTitle:title
                        Subway:subway
                        Photos:nil
                          Menu:nil
                       Reviews:nil
                      TempleID:templeID
                   LowestPrice:150
                        Rating:0
                           Cap:NO
                        Gloves:NO
                      Latitude:latitude
                    Longtitude:longitude];
}

@end
