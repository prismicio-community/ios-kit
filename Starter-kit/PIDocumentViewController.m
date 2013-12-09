//
//  PIDocumentViewController.m
//  Starter-kit
//
//  Created by Étienne VALLETTE d'OSIA on 04/12/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import "PIDocumentViewController.h"

@interface PIDocumentViewController ()

@end

@implementation PIDocumentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [self.document firstTitle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
