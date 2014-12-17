///
//  DSGPhotoAlbumTableViewController.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 18/04/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGAlbumTableViewController.h"
//#import "DSGCollectionsSearchViewController.h"
#import "DSGNestedCollectionViewController.h"

#import "SDWebImage/UIImageView+WebCache.h"
#import "DSGPhotoAlbumTableViewCell.h"
//#import "DSGPhotoSet.h"
#import "DSGPhotoCollection.h"

@interface DSGAlbumTableViewController ()

@end

@implementation DSGAlbumTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:self.navigationItem.title];
    
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
    return [self.albumCollection count];
}


- (DSGPhotoAlbumTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *photoSetCellID = @"_PHOTO_SET_ID_";
    
    DSGPhotoAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:photoSetCellID forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[DSGPhotoAlbumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:photoSetCellID];
    }
    
    DSGPhotoCollection *collection = [self.albumCollection objectAtIndex:indexPath.row];
    [cell.titleLabel setFont:[DSGUtilities fontTyploaWithSize:35]];
    
    cell.titleLabel.layer.shadowColor = [[UIColor whiteColor] CGColor];
    cell.titleLabel.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    cell.titleLabel.layer.shadowOpacity = 1.0f;
    cell.titleLabel.layer.shadowRadius = 1.0f;
    
    [cell.titleLabel setText:[collection.title uppercaseString]];
    [cell.backgroundImage setImageWithURL:[collection getRandomCoverImageURL] placeholderImage:[DSGUtilities placeholderImage]];
    
    return cell;
}

#pragma mark - Navigation Title
-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationItem setTitle:[NSString string]];
    [super viewWillDisappear:animated];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:self.title];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)sender];
    DSGPhotoCollection *selectedCollection = [self.albumCollection objectAtIndex:indexPath.row];
    
    [(DSGNestedCollectionViewController *)segue.destinationViewController setPhotoCollection:selectedCollection];
    [[(DSGNestedCollectionViewController *)segue.destinationViewController navigationItem] setTitle:[[selectedCollection title] uppercaseString]];
    
}


@end
