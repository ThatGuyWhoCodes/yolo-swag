//
//  DSGFeaturedTableViewController.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 12/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGTrendsTableViewController.h"
#import "DSGTrendsTableViewCell.h"

#import "MBProgressHUD.h"
#import "SDWebImage/UIImageView+WebCache.h"

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
            });
        }
        
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

#pragma mark - Refresh Control
-(void)refresh:(id)sender
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
            });
        }
        
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
    return [self.trendsModel numberOfTrends];
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
    
    //NSLog(@"Long: %@", photoAlbum.title);
    
    [cell.titleLabel setFont:[UIFont fontWithName:@"Typola" size:35.0]];
    
    cell.titleLabel.layer.shadowColor = [[UIColor whiteColor] CGColor];
    cell.titleLabel.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    cell.titleLabel.layer.shadowOpacity = 1.0f;
    cell.titleLabel.layer.shadowRadius = 1.0f;
    
    [cell.titleLabel setText:photoAlbum.title];
    [cell.backgroundImage setImageWithURL:photoAlbum.coverUrl placeholderImage:[UIImage imageNamed:@"IMG_0038.JPG"]];
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
