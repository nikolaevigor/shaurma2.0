//
//  sliderCell.h
//  shaurmApp
//
//  Created by Igor Nikolaev on 08.09.15.
//  Copyright (c) 2015 Nikolaev Igor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface sliderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *templePic;
@property (weak, nonatomic) IBOutlet UILabel *templeTitle;
@property (weak, nonatomic) IBOutlet UIImageView *ratePic;
@property (weak, nonatomic) IBOutlet UILabel *price;

@end
