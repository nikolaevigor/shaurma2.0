//
//  sliderVC.m
//  shaurmApp
//
//  Created by Igor Nikolaev on 07.09.15.
//  Copyright (c) 2015 Nikolaev Igor. All rights reserved.
//

#import "sliderVC.h"
#import "sliderCell.h"
#import "Parse.h"
#import "SHMManager.h"
#import "containerDelegate.h"
#import "mapContainer.h"

@interface sliderVC ()

@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) NSArray *nearestTemples;
@property (weak, nonatomic) id <containerDelegate> containerDelegate;
@property (strong, nonatomic) NSMutableDictionary *nearestTemplesIcons;

@end

@implementation sliderVC

- (void)viewDidLoad {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.view.backgroundColor = [UIColor colorWithRed:240.0f/255.0f
                                                green:240.0f/255.0f
                                                 blue:240.0f/255.0f
                                                alpha:1.0f];
    
    
    
    UITabBarController *mainTabBar = (UITabBarController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    UINavigationController *localNavController = (UINavigationController *)[mainTabBar viewControllers][1];
    mapContainer *container = [localNavController viewControllers][0];
    self.containerDelegate = container;
    
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 64)];
    welcomeLabel.text = @"Рядом со мной";
    welcomeLabel.textAlignment = NSTextAlignmentCenter;
    welcomeLabel.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:1.0f];
    welcomeLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:welcomeLabel];
    
    UIButton *welcomeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, screenRect.size.width, 50)];
    //[welcomeButton setTitle:@"Рядом со мной" forState:UIControlStateNormal];
    //[welcomeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [welcomeButton setImage:[UIImage imageNamed:@"Expand"] forState:UIControlStateNormal];
    [welcomeButton setBackgroundColor:[UIColor blackColor]];
    
    [welcomeButton addTarget:self action:@selector(getBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:welcomeButton];
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 114, screenRect.size.width, screenRect.size.height - 114 - 49)];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.scrollEnabled = YES;
    self.table.rowHeight = UITableViewAutomaticDimension;
    self.table.estimatedRowHeight = 70.0;
    self.table.backgroundColor = [UIColor colorWithRed:240.0f/255.0f
                                                 green:240.0f/255.0f
                                                  blue:240.0f/255.0f
                                                 alpha:1.0f];
    [self.table registerNib:[UINib nibWithNibName:@"sliderCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:self.table];
    
    [super viewDidLoad];
}

- (void)getBack
{
    [self.containerDelegate pop];
}

#pragma mark - Table View methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellID";
    
    sliderCell *cell = (sliderCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[sliderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *temple = self.nearestTemples[indexPath.row];
    [(sliderCell *)cell templeTitle].text = temple[@"title"];
    [(sliderCell *)cell price].text = [NSString stringWithFormat:@"%@ ₽", temple[@"price"]];
    [(sliderCell *)cell ratingLabel].text = [temple[@"ratingNumber"] stringValue];
    
    
    
    if([temple[@"subway"] isEqualToString:@"N/A"] || [temple[@"subway"] isEqualToString:@"Subway_Name"])
    {
        [(sliderCell *)cell metroLabel].text = @"Нет метро";
    }
    else if([SHMManager isStation:temple[@"subway"]]){
        [(sliderCell *)cell metroLabel].text = temple[@"subway"];
    }
    else{
        [(sliderCell *)cell metroLabel].text = [NSString stringWithFormat:@"ст. %@", temple[@"subway"]];
    }
    
    [(sliderCell *)cell metroLabel].textColor = [SHMManager colorForStation:temple[@"subway"]];
    
    if ([self.nearestTemplesIcons objectForKey:temple[@"title"]])
    {
        [(sliderCell *)cell templePic].image = [self image:[self.nearestTemplesIcons objectForKey:temple[@"title"]] scaledToSize:CGSizeMake(30.0f, 40.0f)];
    }
    else
    {
        [(sliderCell *)cell templePic].image = [UIImage imageNamed:@"small-placeholder"];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.nearestTemples.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static sliderCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    PFObject *temple = self.nearestTemples[indexPath.row];
    [cell templeTitle].text = temple[@"title"];
    [cell price].text = [NSString stringWithFormat:@"%@ ₽", temple[@"price"]];
    [cell ratingLabel].text = [temple[@"ratingNumber"] stringValue];
    [cell metroLabel].text = temple[@"subway"];
    
    return [self calculateHeightForConfiguredSizingCell:cell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 10; //this is not good i assume
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *temple = self.nearestTemples[indexPath.row];
    [self.containerDelegate openTempleVC:[temple objectId]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - sliderDelegate methods

- (void)setTableViewWith:(NSArray *)temples
{
    self.nearestTemplesIcons = [[NSMutableDictionary alloc] init];
    self.nearestTemples = temples;
    for (int i=0; i<temples.count; i++) {
        [temples[i][@"picture"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                [self.nearestTemplesIcons setObject:[UIImage imageWithData:data] forKey:temples[i][@"title"]];
                [self.table reloadData];
            }
        }];
    }
    [self.table reloadData];
}

#pragma mark - Nice snippets

- (UIImage *)image:(UIImage*)originalImage scaledToSize:(CGSize)size
{
    if (CGSizeEqualToSize(originalImage.size, size))
    {
        return originalImage;
    }
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
