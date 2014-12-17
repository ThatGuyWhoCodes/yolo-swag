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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self refreshModelWithCompletionBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            });
        }];
    });
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationItem setTitle:[NSString string]];
    [super viewWillDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setTitle:title];
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // iOS 7
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    // iOS 8
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews
{
    // iOS 7
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    // iOS 8
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

# pragma mark - Model interaction

- (void)refreshModelWithCompletionBlock:(void (^)(void))complection
{
    __weak DSGSeasonTableViewController *weakSelf = self;
    
    [self.browseModel fetchDataWithCompletionBlock:^(BOOL complete) {
        
        if (complete)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"Unable to retirve photos, try again later" delegate:weakSelf cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                
                //Display 'no connection image' is model is empty
                if ([weakSelf.browseModel count] < 1)
                {
                    UIButton *refreshButton = [DSGUtilities noConnectionButtonWithTarget:weakSelf selector:@selector(retryConnection:)];
                    [weakSelf.view addSubview:refreshButton];
                }
            });
        }
        
        complection();
        
    }];
}

#pragma mark - Retry Connection

-(void)retryConnection:(id)sender
{
    //Remove the button from view
    [sender removeFromSuperview];
    
    //Add a progress wheel
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //Attempt to pull new data
    __weak DSGSeasonTableViewController *weakSelf = self;
    [self refreshModelWithCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        });
    }];
}


#pragma mark - Refresh Control

-(void)refresh:(id)sender
{
    [self refreshModelWithCompletionBlock:^{
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
        cell.imageView.contentMode = UIViewContentModeScaleToFill;
    }
    
    DSGNestedCollection* collection = [self.browseModel.collectionsData objectAtIndex:indexPath.row];
    [cell.titleLabel setFont:[DSGUtilities fontTyploaWithSize:35]];
    
    cell.titleLabel.layer.shadowColor = [[UIColor whiteColor] CGColor];
    cell.titleLabel.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    cell.titleLabel.layer.shadowOpacity = 1.0f;
    cell.titleLabel.layer.shadowRadius = 2.0f;
    
    [cell.titleLabel setText:[[collection title] uppercaseString]];
    [cell.cellBackGroundImage setImage:[DSGUtilities imageForTitle:[collection title]]];
    
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
    DSGNestedCollection *currentCollection = [self.browseModel.collectionsData objectAtIndex:indexPath.row];
    
    [(DSGAlbumTableViewController *)segue.destinationViewController setAlbumCollection:[currentCollection collectionCollection]];
    [[(DSGAlbumTableViewController *)segue.destinationViewController navigationItem] setTitle:[[currentCollection title] uppercaseString]];
}


@end
