//
//  TGOViewController.m
//  Just Some Stuff
//
//  Created by MacBrian Pro on 30/03/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGHomeViewController.h"
#import "DSGHomeCollectionViewCell.h"
#import "DSGPhotoInfoViewController.h"

static NSString *title = @"CAMPAIGNS";

@implementation DSGHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.homeModel = [DSGHomeModel sharedInstance];
    //Add the refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:refreshControl];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    __weak DSGHomeViewController *weakSelf = self;
    
    [self refreshModelWithCompletionBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
             [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        });
    }];
}

# pragma mark - Navigation title managment
-(void)viewWillDisappear:(BOOL)animated
{
    //Set the title to an empty string to remove the title
    [self.navigationItem setTitle:[NSString string]];
}

-(void)viewWillAppear:(BOOL)animated
{
    //Reset the Navigation title
    [self.navigationItem setTitle:title];
    
    //If the momdel is empty, try and get new data
    /*
    if ([self.homeModel.photoData count] < 1)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [self refreshModelWithCompletionBlock:^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Model interaction
- (void)refreshModelWithCompletionBlock:(void (^)(void))complection
{
    __weak DSGHomeViewController *weakSelf = self;
    
    [self.homeModel freshPullWithCompletionBlock:^(BOOL complete) {
        
        if (complete)
        {
            [weakSelf.collectionView reloadData];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"Unable to retirve photos, try again later" delegate:weakSelf cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
            });
        }
            complection();
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

#pragma mark - Collection View Data Source
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
    [cell.image setImageWithURL:[currentPhoto imageURL] placeholderImage:[DSGUtilities placeholderImage]]; //TODO: Replace PlaceHolder
    
    [cell.label setText:[currentPhoto title]];
    
    return cell;
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
    [self.homeModel setSelectedPhotoAtIndex:indexPath.row];
    
    [[segue.destinationViewController navigationItem] setTitle:self.homeModel.selectedPhoto.title];
    //[((DSGPhotoInfoViewController*)segue.destinationViewController) setBasicPhoto:self.homeModel.selectedPhoto];
    [((DSGPhotoInfoViewController*)segue.destinationViewController) setImageAlbum:self.homeModel];
    
}
@end
