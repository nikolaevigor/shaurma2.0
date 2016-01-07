//
//  sliderVC.m
//  shaurmApp
//
//  Created by Igor Nikolaev on 07.09.15.
//  Copyright (c) 2015 Nikolaev Igor. All rights reserved.
//

#import "sliderVC.h"

@interface sliderVC ()
{
    CGRect screenRect;
    templeSingleton *singleton;
}

@end

@implementation sliderVC

- (void)viewDidLoad {
    screenRect = [[UIScreen mainScreen] bounds];
    singleton = [[templeSingleton alloc]init];
    
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *welcomeLabel = [[UILabel alloc] initWithFrame:CGRectMake(screenRect.size.width/2 - 60, 0, 150, 50)];
    welcomeLabel.text = @"Рядом со мной";
    [self.view addSubview:welcomeLabel];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, screenRect.size.width, 500)];
    table.scrollEnabled = NO;
    table.delegate = self;
    table.dataSource = self;
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
    
    cell.templePic.image = [UIImage imageNamed:@"shawermag.jpg"];
    cell.templeTitle.text = [singleton.allTemples objectAtIndex:indexPath.row][@"title"];
    cell.price.text = [[singleton.allTemples objectAtIndex:indexPath.row][@"price"] stringValue];
    cell.ratePic.image = [UIImage imageNamed:@"r7.png"];
    
    return cell;
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
