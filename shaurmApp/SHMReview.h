//
//  SHMReview.h
//  shaurmApp
//
//  Created by Igor Nikolaev on 25/03/16.
//  Copyright © 2016 NikolaevIgor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHMReview : NSObject

@property (nonnull, strong, nonatomic) NSString *author;
@property (nonnull, strong, nonatomic) NSDate *date;
@property (nonnull, strong, nonatomic) NSString *text;
@property (nullable, strong, nonatomic) NSArray *photos;
@property (nonnull, strong, nonatomic) NSString *reviewID;
@property NSUInteger rating;

// Prohibited
- (nonnull instancetype)init __unavailable;
+ (nonnull instancetype)new __unavailable;

// designated intializer
- (nonnull instancetype)initWithAuthor:(nonnull NSString *)author
                                  Date:(nonnull NSDate *)date
                                  Text:(nonnull NSString *)text
                                Photos:(nullable NSArray *)photos
                              ReviewID:(nonnull NSString *)reviewID
                                Rating:(NSUInteger)rating;

@end
