//
//  SHMChildViewController.m
//  shaurmApp
//
//  Created by Igor Nikolaev on 14/03/16.
//  Copyright © 2016 NikolaevIgor. All rights reserved.
//

#import "SHMChildViewController.h"

@interface SHMChildViewController ()


@end

@implementation SHMChildViewController

NSArray *textArray = nil;
NSArray *imgArray = nil;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    textArray = [NSArray arrayWithObjects:@"Лучшие киоски и кафе в городе",@"Лучшая шаурма из ближайшего",@"Ставь оценки и оставляй рецензии", nil];
    imgArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"tut0"],[UIImage imageNamed:@"tut1"],[UIImage imageNamed:@"tut2"], nil];

    return self;
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if( [[UIScreen mainScreen] bounds].size.width == 320) {
        self.imgHeight.constant = 440;
        self.imgBottomConstr.constant = -52;
        self.appetiteTopConstr.constant = 30;

    }
    
    if (self.index == 3) {
        [self.dismissButton setHidden:NO];
        [self.appetiteLabel setHidden:NO];
        [self.hcocbLabel setHidden:NO];
        [self.forkImage setHidden:NO];
        [self.tutImage setHidden:YES];
        [self.screenNumber setHidden:YES];
    }
    
    if (self.index < 3) {
        self.screenNumber.text = textArray[(long)self.index];
        self.tutImage.image = imgArray[(long)self.index];
    }

}
- (IBAction)buttonPressed:(id)sender {
    [self.delegate finishTutorial];
}


@end
