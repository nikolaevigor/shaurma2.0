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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    if (self.index != 4) {
        [self.dismissButton setHidden:YES];
    }
    
    self.screenNumber.text = [NSString stringWithFormat:@"Screen #%ld", (long)self.index];
    
}
- (IBAction)buttonPressed:(id)sender {
    [self.delegate finishTutorial];
}

@end
