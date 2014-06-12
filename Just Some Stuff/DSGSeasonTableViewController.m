//
//  DSGBrowseTableViewController.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 18/04/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGSeasonTableViewController.h"
#import "DSGAlbumTableViewController.h"
#import "DSGCollectionTableViewCell.h"
#import "MBProgressHUD.h"


static NSString *title = @"BROWSE";

@implementation DSGSeasonTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Add the refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    self.browseModel = [DSGSeasonModel sharedInstance];
    
    __weak DSGSeasonTableViewController *weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.browseModel fetchDataWithCompletionBlock:^(BOOL complete) {
        
        if (complete)
        {
            [weakSelf.tableView reloadData];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                 [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"Unable to retirve photos, trya again later" delegate:weakSelf cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        });
        
    }];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationItem setTitle:[NSString string]];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setTitle:title];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)refresh:(id)sender
{
    __weak DSGSeasonTableViewController *weakSelf = self;
    [self.browseModel fetchDataWithCompletionBlock:^(BOOL complete) {
        
        if (complete)
        {
            [weakSelf.tableView reloadData];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"Unable to retirve photos, trya again later" delegate:weakSelf cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [sender endRefreshing];
        });
    }];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.browseModel.collectionsData count];
}


- (DSGCollectionTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableCellID = @"_BROWSE_CELL_ID_";
    
    DSGCollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellID forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[DSGCollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellID];
    }
    
    DSGPhotoCollection* collection = [self.browseModel.collectionsData objectAtIndex:indexPath.row];
    [cell.titleLabel setFont:[DSGUtilities fontTyploaWithSize:35]];
    [cell.titleLabel setText:[[collection title] uppercaseString]];
    
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
    DSGPhotoCollection *currentCollection = [self.browseModel.collectionsData objectAtIndex:indexPath.row];
    
    [(DSGAlbumTableViewController *)segue.destinationViewController setPhotoSet:[currentCollection collectionImageSet]];
    [[(DSGAlbumTableViewController *)segue.destinationViewController navigationItem] setTitle:[[currentCollection title] uppercaseString]];
}


@end
