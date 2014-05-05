//
//  TGOViewController.m
//  Just Some Stuff
//
//  Created by MacBrian Pro on 30/03/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGHomeViewController.h"
#import "MBProgressHUD.h"
#import "DSGHomeCollectionViewCell.h"
#import "SDWebImage/UIImageView+WebCache.h"

@implementation DSGHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.homeModel = [DSGHomeModel sharedInstance];
    //Add the refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];

    __weak DSGHomeViewController *weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.homeModel freshPullWithCompletionBlock:^(BOOL complete) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (complete)
        {
            [weakSelf.collectionView reloadData];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"Unable to retirve photos, try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
    }];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)refresh:(id)sender
{
    __weak DSGHomeViewController *weakSelf = self;
    
    [self.homeModel freshPullWithCompletionBlock:^(BOOL complete) {
        
        [sender endRefreshing];
        if (complete)
        {
            [weakSelf.collectionView reloadData];
        }
        else
        {
            [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"Unable to retirve photos, try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
        }
    }];
}

#pragma mark - CollectionView
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.homeModel.photoData count];
}

-(DSGHomeCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DSGHomeCollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[DSGHomeCollectionViewCell alloc] init];
    }
    
    DSGBasicPhoto *currentPhoto = [self.homeModel.photoData objectAtIndex:indexPath.row];
    [cell.image setContentMode:UIViewContentModeScaleAspectFill];
    [cell.image setImageWithURL:[currentPhoto imageURL] placeholderImage:[UIImage imageNamed:@"IMG_0038.JPG"]];
    
    [cell.label setText:[currentPhoto title]];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
    
    if ([self.homeModel setSelectedPhotoUsingIndex:indexPath.row])
    {
        [[segue.destinationViewController navigationItem] setTitle:self.homeModel.selectedPhoto.title];
    }
    else
    {
        [[segue.destinationViewController navigationItem] setTitle:@"Image"];
    }
    
    
    
}
@end
