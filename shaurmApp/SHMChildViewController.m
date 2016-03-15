//
//  SHMChildViewController.m
//  shaurmApp
//
//  Created by Igor Nikolaev on 14/03/16.
//  Copyright © 2016 NikolaevIgor. All rights reserved.
//

#import "SHMChildViewController.h"

@interface SHMChildViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *tutImage;

@end

@implementation SHMChildViewController

NSArray *textArray = nil;
NSArray *imgArray = nil;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    textArray = [NSArray arrayWithObjects:@"Лучшая шаурма в городе",@"Лучшая шаурма поблизости",@"Лучшая шаурма поблизости", nil];
    
    
    imgArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"tut0"],[UIImage imageNamed:@"tut1"],[UIImage imageNamed:@"tut3"], nil];

    return self;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    if (self.index != 4) {
        [self.dismissButton setHidden:YES];
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
