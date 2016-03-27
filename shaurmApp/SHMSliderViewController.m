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
#import "SHMTemple.h"
#import "SHMManager.h"

@interface SHMSliderViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) id <SHMMapDelegate> delegate;
@property (strong, nonatomic) UITableView *table;
@property NSArray *temples;

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
    SHMTemple *temple = self.temples[indexPath.row];
    [(sliderCell *)cell templeTitle].text = [temple title];
    [(sliderCell *)cell price].text = [NSString stringWithFormat:@"%lu", (unsigned long)[temple lowestPrice]];
    [(sliderCell *)cell ratingLabel].text = [NSString stringWithFormat:@"%lu", (unsigned long)[temple rating]];
    
    
    
    if([[temple subway] isEqualToString:@"N/A"] || [[temple subway] isEqualToString:@"Subway_Name"])
    {
        [(sliderCell *)cell metroLabel].text = @"Нет метро";
    }
    else if([SHMManager isStation:[temple subway]]){
        [(sliderCell *)cell metroLabel].text = [temple subway];
    }
    else{
        [(sliderCell *)cell metroLabel].text = [NSString stringWithFormat:@"ст. %@", [temple subway]];
    }
    
    [(sliderCell *)cell metroLabel].textColor = [SHMManager colorForStation:[temple subway]];
    
    if ([temple photos])
    {
        [(sliderCell *)cell templePic].image = [self image:temple.photos[0] scaledToSize:CGSizeMake(30.0f, 40.0f)];
    }
    else
    {
        [(sliderCell *)cell templePic].image = [UIImage imageNamed:@"small-placeholder"];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.temples count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static sliderCell *cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    SHMTemple *temple = self.temples[indexPath.row];
    [cell templeTitle].text = [temple title];
    [cell price].text = [NSString stringWithFormat:@"%lu", (unsigned long)[temple lowestPrice]];
    [cell ratingLabel].text = [NSString stringWithFormat:@"%lu", (unsigned long)[temple rating]];
    [cell metroLabel].text = [temple subway];
    
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

- (void)setTableWithTemples:(NSArray *)temples
{
    self.temples = temples;
    [self.table reloadData];
}

#pragma mark - Nice snippets

//method for resizing image
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

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 10; //this is not good i assume
}

@end
