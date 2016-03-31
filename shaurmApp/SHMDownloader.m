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
            NSMutableArray *temples = [[NSMutableArray alloc] init];
            for (int i = 0; i < objects.count; i++)
            {
                PFObject *rawObject = objects[i];
                PFGeoPoint *geoPoint = rawObject[@"location"];
                
                SHMTemple *temple = [[SHMTemple alloc] initWithTitle:rawObject[@"title"]
                                                              Subway:rawObject[@"subway"]
                                                              Photos:nil
                                                                Menu:nil//set
                                                             Reviews:nil//set
                                                            TempleID:rawObject.objectId
                                                         LowestPrice:[rawObject[@"price"] integerValue]
                                                              Rating:[rawObject[@"ratingNumber"] integerValue]
                                                                 Cap:rawObject[@"cap"]
                                                              Gloves:rawObject[@"gloves"]
                                                            Latitude:geoPoint.latitude
                                                          Longitude:geoPoint.longitude
                                     ];
                [rawObject[@"picture"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error) {
                        NSArray *photosArray = [NSArray arrayWithObject:[UIImage imageWithData:data]];
                        [temple setPhotos:photosArray];
                    }
                }];
                [temples addObject:temple];
                
            }
            completeion([temples copy]);
        }
        else
        {
            NSLog(@"Error occured in getting temples: %@", error.localizedDescription);
        }
    }];
}

+ (void)getTempleByID:(NSString *)templeID WithBlock:(void (^)(SHMTemple *))completeion
{
    PFQuery *query = [PFQuery queryWithClassName:@"Temples2"];
    [query getObjectInBackgroundWithId:templeID block:^(PFObject *rawObject, NSError *error) {
        PFGeoPoint *geoPoint = rawObject[@"location"];
        
        SHMTemple *temple = [[SHMTemple alloc] initWithTitle:rawObject[@"title"]
                                                      Subway:rawObject[@"subway"]
                                                      Photos:nil
                                                        Menu:nil//set
                                                     Reviews:nil//set
                                                    TempleID:rawObject.objectId
                                                 LowestPrice:[rawObject[@"price"] integerValue]
                                                      Rating:[rawObject[@"ratingNumber"] integerValue]
                                                         Cap:rawObject[@"cap"]
                                                      Gloves:rawObject[@"gloves"]
                                                    Latitude:geoPoint.latitude
                                                  Longitude:geoPoint.longitude
                             ];
        completeion([temple copy]);
    }];
}

@end
