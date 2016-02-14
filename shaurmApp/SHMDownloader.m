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
    PFQuery *query = [PFQuery queryWithClassName:@"Temples2"];
    query.limit = 500;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error)
        {
            completeion(objects);
        }
        else
        {
            NSLog(@"Error occured in getting temples: %@", error.localizedDescription);
        }
    }];
}

@end
