//
//  sliderDelegate.h
//  shaurmApp
//
//  Created by Igor Nikolaev on 09/01/16.
//  Copyright © 2016 NikolaevIgor. All rights reserved.
//

@class PFObject;

@protocol sliderDelegate

- (void)setTableViewWith:(NSArray *)temples;
- (void)setUserInteractions:(BOOL)isAvailable;

@end