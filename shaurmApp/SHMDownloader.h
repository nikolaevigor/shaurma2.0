//
//  SHMDownloader.h
//  shaurmApp
//
//  Created by Igor Nikolaev on 08/01/16.
//  Copyright © 2016 NikolaevIgor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SHMDownloader : NSObject

+ (void)getTemplesInBackgroundWithBlock:(void (^)(NSArray *))completeion;

@end
