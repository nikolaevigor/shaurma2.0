//
//  containerDelegate.h
//  shaurmApp
//
//  Created by Igor Nikolaev on 09/01/16.
//  Copyright © 2016 NikolaevIgor. All rights reserved.
//

@protocol containerDelegate

- (void)templesIsDownloaded;
- (void)refreshSlider;
- (void)openTempleVC:(NSString *)id_;

@end