//
//  sliderVC.m
//  shaurmApp
//
//  Created by Igor Nikolaev on 07.09.15.
//  Copyright (c) 2015 Nikolaev Igor. All rights reserved.
//

#import "sliderVC.h"
#import "sliderCell.h"

@interface sliderVC ()

@end

@implementation sliderVC

- (void)viewDidLoad {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenRect.size.width/2 - 60, 0, 150, 50)];
    welcomeLabel.text = @"Рядом со мной";
    [self.view addSubview:welcomeLabel];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenRect.size.width, 500)];
    table.delegate = self;
    table.dataSource = self;
    table.scrollEnabled = NO;
    [table registerNib:[UINib nibWithNibName:@"sliderCell" bundle:nil] forCellReuseIdentifier:@"cellID"];
    [self.view addSubview:table];
    
    [super viewDidLoad];
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
    [(sliderCell *)cell templeTitle].text = @"Title Test";
    [(sliderCell *)cell price].text = @"Price Test";
    [(sliderCell *)cell ratingLabel].text = @"3";
    //[(sliderCell *)cell templePic]
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

@end
