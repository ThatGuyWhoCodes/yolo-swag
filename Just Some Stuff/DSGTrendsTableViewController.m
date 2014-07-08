//
//  DSGFeaturedTableViewController.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 12/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGTrendsTableViewController.h"
#import "DSGCollectionsSearchViewController.h"
#import "DSGTrendsTableViewCell.h"

static NSString *title = @"BE INSPIRED";

@interface DSGTrendsTableViewController ()

@end

@implementation DSGTrendsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Add the refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    self.trendsModel = [DSGTrendsModel sharedInstance];
    
    __weak DSGTrendsTableViewController *weakSelf = self;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self refreshModelWithCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        });
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Navigation Title
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationItem setTitle:[NSString string]];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setTitle:title];
}

# pragma mark - Model interaction

- (void)refreshModelWithCompletionBlock:(void (^)(void))complection
{
    __weak DSGTrendsTableViewController *weakSelf = self;
    
    [self.trendsModel fetchDataWithCompletionBlock:^(BOOL complete) {
        if (complete)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"Unable to retirve photos, trya again later" delegate:weakSelf cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                
                //Display 'no connection image' is model is empty
                if ([weakSelf.trendsModel count] < 1)
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
    __weak DSGTrendsTableViewController *weakSelf = self;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.trendsModel count];
}


- (DSGTrendsTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_id = @"_TRENDS_CELL_ID_";
    
    DSGTrendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    
    if (!cell)
    {
        cell = [[DSGTrendsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_id];
    }
    
    DSGPhotoSet *photoAlbum = [self.trendsModel.featuredTrends objectAtIndex:indexPath.row];
    
    [cell setCellText:[photoAlbum.title uppercaseString]];
    [cell setCellImage:photoAlbum.coverUrl];
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForCell:sender];
    DSGPhotoSet *selectedPhotoSet = [self.trendsModel.featuredTrends objectAtIndex:selectedIndexPath.row];
    
    [(DSGCollectionsSearchViewController *)segue.destinationViewController setPhotoSet:selectedPhotoSet];
    [[(DSGCollectionsSearchViewController *)segue.destinationViewController navigationItem] setTitle:[[selectedPhotoSet title] uppercaseString]];
}


@end
