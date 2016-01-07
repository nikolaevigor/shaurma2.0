//
//  SHMDownloader.m
//  shaurmApp
//
//  Created by Igor Nikolaev on 08/01/16.
//  Copyright © 2016 NikolaevIgor. All rights reserved.
//

#import "SHMDownloader.h"
#import "Parse.h"

@implementation SHMDownloader

+ (void)getTemplesInBackgroundWithBlock:(void (^)(NSArray *))completeion
{
    PFQuery *query = [PFQuery queryWithClassName:@"Temple"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        completeion(objects);
    }];
}

@end
