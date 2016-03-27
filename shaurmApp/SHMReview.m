//
//  SHMReview.m
//  shaurmApp
//
//  Created by Igor Nikolaev on 25/03/16.
//  Copyright © 2016 NikolaevIgor. All rights reserved.
//

#import "SHMReview.h"

@implementation SHMReview

// designated intializer
- (nonnull instancetype)initWithAuthor:(nonnull NSString *)author
                                  Date:(nonnull NSDate *)date
                                  Text:(nonnull NSString *)text
                                Photos:(nullable NSArray *)photos
                              ReviewID:(nonnull NSString *)reviewID
                                Rating:(NSUInteger)rating
{
    if (self = [super init]) {
        _author = author;
        _date = date;
        _text = text;
        _reviewID = reviewID;
        _rating = rating;
        if (photos) {
            _photos = photos;
        }
    }
    return self;
}

@end
