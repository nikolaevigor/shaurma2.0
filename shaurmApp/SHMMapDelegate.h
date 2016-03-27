//
//  SHMMapDelegate.h
//  shaurmApp
//
//  Created by Igor Nikolaev on 27/03/16.
//  Copyright © 2016 NikolaevIgor. All rights reserved.
//

@protocol SHMMapDelegate

- (void)showSlider;
- (void)showMap;
- (void)setCurrentLocationWithLatitude:(float)latitude Longitude:(float)longitude;
- (void)openTempleViewControllerWithID:(NSString *)templeID;

@end
