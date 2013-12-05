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
    self.title = [self.form name];
    PISearchForm *searchForm = [self.api searchFormForName:[self.form name]];
    [searchForm setRefName:@"Master"];
    NSError *error = nil;
    PISearchResult *searchResult = [searchForm submit:&error];
    if (error == nil) {
        NSLog(@"OK");
    }
    else {
        NSLog(@"KO");
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
