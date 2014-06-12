//
//  DSGCollectionsSearchViewController.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 05/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGCollectionsSearchViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "DSGPhotoAlbumCollectionViewCell.h"
#import "DSGPhotoInfoViewController.h"

@implementation DSGCollectionsSearchViewController

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
    [self setTitle:self.navigationItem.title];
    // Do any additional setup after loading the view.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationItem setTitle:[NSString string]];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setTitle:self.title];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setPhotoSet:(DSGPhotoSet *)photoSet
{
    [self setAlbumModel:[[DSGAlbumModel alloc] initWithPhotoSet:photoSet]];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.albumModel numberOfPhotos];
}

-(DSGPhotoAlbumCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *collCellID = @"_SET_ITEM_ID_";
    
    DSGPhotoAlbumCollectionViewCell *collectioViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:collCellID forIndexPath:indexPath];
    
    if (!collectioViewCell)
    {
        collectioViewCell = [[DSGPhotoAlbumCollectionViewCell alloc] init];
    }
    
    [collectioViewCell.imageView setImageWithURL:[self.albumModel photoURLAtIndex:indexPath.row] placeholderImage:[UIImage imageNamed:@"IMG_0038.JPG"]]; //TODO: Replace PlaceHolder
    
    return collectioViewCell;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    
    NSString *searchString = [[searchBar text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    __weak DSGCollectionsSearchViewController* weakSelf = self;
    if ([searchString length] > 0)
    {
        [self.albumModel searchAblumUsingText:[searchString lowercaseString] completionBlock:^(BOOL complete) {
            if (complete)
            {
                //NSLog(@"Complete");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.collectionView reloadData];
                });
            }
            else
            {
                //NSLog(@"Not Complete");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:@"No Results Found" message:@"Chnage search term" delegate:weakSelf cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                });
            }
        }];
    }
    else
    {
        [self.albumModel reset];
        [self.collectionView reloadData];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"Cancelled");
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
    [self.albumModel setSelectedPhotoAtIndex:indexPath.row];
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    DSGBasicPhoto *selectedPhoto = [self.albumModel getSelectedPhoto];
    [[segue.destinationViewController navigationItem] setTitle:[[selectedPhoto title] uppercaseString]];
    
    //[((DSGPhotoInfoViewController*)segue.destinationViewController) setBasicPhoto:selectedPhoto];
    [((DSGPhotoInfoViewController*)segue.destinationViewController) setImageAlbum:self.albumModel];
}


@end
