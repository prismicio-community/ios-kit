//
//  PIDocumentsListViewController.m
//  Starter-kit
//
//  Created by Étienne VALLETTE d'OSIA on 27/11/2013.
//  Copyright (c) 2013 Zengularity. All rights reserved.
//

#import "PIDocumentsListViewController.h"

#import "PIDocumentViewController.h"

#import "PIAPI/PIAPI.h"

@interface PIDocumentsListViewController ()

@property NSMutableArray* documents;

@property PIAPI *api;

@end

@implementation PIDocumentsListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString: @"https://lesbonneschoses-uj8crgij1aniotz.prismic.io/api"];
    NSString *accessToken = @"MC5VbGdWemJPNTN5VW41czlC.X0nvv73vv73vv71d77-9PO-_ve-_ve-_ve-_ve-_ve-_ve-_vT5NJWMv77-977-9JTAKCO-_vXvvv70NflM";
    NSError *error = nil;
    self.api = [PIAPI apiWithURL:url andAccessToken:accessToken error:&error];
    if (error == nil) {
        self.documents = [[NSMutableArray alloc] init];
        [self loadInitialData];
    }
    else {
        NSLog(@"Error while fetching API: %@", error);
    }

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)loadInitialData {
    NSDictionary *forms = [self.api forms];
    for (NSString *formName in forms) {
        PIForm *form = [self.api formForName:formName];
        [self.documents addObject: form];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.documents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ListPrototypeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    

    PIForm *form = [self.documents objectAtIndex:indexPath.row];
    cell.textLabel.text = [form name];
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCe searchFormForName:[form name]];llEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (PIForm *) detailForIndexPath:(NSIndexPath *)indexPath
{
    return [self.documents objectAtIndex:indexPath.row];
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"TO_DOCUMENT_VIEW"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        PIDocumentViewController *documentViewController = [segue destinationViewController];
        documentViewController.api = self.api;
        documentViewController.form = [self detailForIndexPath:indexPath];
    }
}



@end
