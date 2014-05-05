//
//  DSGPhotoAlbumTableViewController.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 18/04/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGPhotoAlbumTableViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "DSGPhotoAlbumTableViewCell.h"
#import "DSGPhotoSet.h"

@interface DSGPhotoAlbumTableViewController ()



@end

@implementation DSGPhotoAlbumTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    return [self.photoSet count];
}


- (DSGPhotoAlbumTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *photoSetCellID = @"_PHOTO_SET_ID_";
    
    DSGPhotoAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:photoSetCellID forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[DSGPhotoAlbumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:photoSetCellID];
    }
    
    DSGPhotoSet *photoSet = [self.photoSet objectAtIndex:indexPath.row];
    [cell.titleLabel setText:photoSet.set_title];
    [cell.backgroundImage setImageWithURL:photoSet.coverUrl placeholderImage:[UIImage imageNamed:@"IMG_0038.JPG"]];
    
    return cell;
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
