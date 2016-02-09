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

@end

@implementation sliderVC

- (void)viewDidLoad {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    
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
    
    UIButton *welcomeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, screenRect.size.width, 64)];
    [welcomeButton setTitle:@"Рядом со мной" forState:UIControlStateNormal];
    [welcomeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [welcomeButton setBackgroundColor:[UIColor blackColor]];
    
    [welcomeButton addTarget:self action:@selector(getBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:welcomeButton];
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 128, screenRect.size.width, 500)];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.scrollEnabled = YES;
    self.table.rowHeight = UITableViewAutomaticDimension;
    self.table.estimatedRowHeight = 70.0;
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
    [(sliderCell *)cell metroLabel].text = temple[@"subway"];
    //[(sliderCell *)cell metroLabel].textColor = [SHMManager colorForStation:temple[@"subway"]];
    //[(sliderCell *)cell templePic].image = [UIImage imageWithData:[temple[@"picture"] getDataInBackground]];
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

#pragma mark - sliderDelegate methods

- (void)setTableViewWith:(NSArray *)temples
{
    self.nearestTemples = temples;
    [self.table reloadData];
}

#pragma mark - Nice snippets


@end
