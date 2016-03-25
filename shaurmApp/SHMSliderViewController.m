//
//  SHMSliderViewController.m
//  shaurmApp
//
//  Created by Igor Nikolaev on 20/03/16.
//  Copyright © 2016 NikolaevIgor. All rights reserved.
//

#import "SHMSliderViewController.h"
#import "SHMMapDelegate.h"
#import "sliderCell.h"

@interface SHMSliderViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) id <SHMMapDelegate> delegate;
@property (strong, nonatomic) UITableView *table;

@end

@implementation SHMSliderViewController

- (instancetype)initWithDelegate:(id)delegate
{
    if (self = [self init])
    {
        self.delegate = delegate;
    }
    return self;
}

- (instancetype)init
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    if (self = [super init])
    {
        UIButton *expandButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 64)];
        [expandButton setTitle:@"Рядом со мной" forState:UIControlStateNormal];
        [expandButton setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:0.55f]];
        
        [expandButton addTarget:self action:@selector(expandSlider) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:expandButton];
        
        UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        blurEffectView.frame = self.view.frame;
        [blurEffectView addSubview:expandButton];
        [self.view addSubview:blurEffectView];
        
        UIButton *collapseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 64, screenRect.size.width, 50)];
        [collapseButton setImage:[UIImage imageNamed:@"Expand2"] forState:UIControlStateNormal];
        [collapseButton setBackgroundColor:[UIColor colorWithRed:21.0f/255.0f green:21.0f/255.0f blue:21.0f/255.0f alpha:1.0f]];
        
        [collapseButton addTarget:self action:@selector(collapseSlider) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:collapseButton];
        
        self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 114, screenRect.size.width, screenRect.size.height - 114 - 49)];
        self.table.delegate = self;
        self.table.dataSource = self;
        self.table.scrollEnabled = YES;
        self.table.rowHeight = UITableViewAutomaticDimension;
        self.table.estimatedRowHeight = 70.0;
        self.table.backgroundColor = [UIColor clearColor];
        [self.table registerNib:[UINib nibWithNibName:@"sliderCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
        [self.view addSubview:self.table];
        [self.table reloadData];
    }
    return self;
}

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
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static sliderCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    PFObject *temple = self.nearestTemples[indexPath.row];
    [cell templeTitle].text = temple[@"title"];
    [cell price].text = [NSString stringWithFormat:@"%@ ₽", temple[@"price"]];
    [cell ratingLabel].text = [temple[@"ratingNumber"] stringValue];
    [cell metroLabel].text = temple[@"subway"];
    
    return [self calculateHeightForConfiguredSizingCell:cell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)expandSlider
{
    [self.delegate showSlider];
}

- (void)collapseSlider
{
    [self.delegate showMap];
}

@end
