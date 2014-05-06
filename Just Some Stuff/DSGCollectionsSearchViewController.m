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
    // Do any additional setup after loading the view.
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
    
    [collectioViewCell.imageView setImageWithURL:[self.albumModel imageURLAtIndex:indexPath.row] placeholderImage:[UIImage imageNamed:@"IMG_0038.JPG"]]; //TODO: Replace PlaceHolder
    
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
                NSLog(@"Complete");
            }
            else
            {
                NSLog(@"Not Complete");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[[UIAlertView alloc] initWithTitle:@"No Results Found" message:@"Chnage search term" delegate:weakSelf cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil] show];
                });
            }
        }];
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    DSGBasicPhoto *selectedPhoto = [self.albumModel.filteredPhotos objectAtIndex:indexPath.row];
    [[segue.destinationViewController navigationItem] setTitle:[selectedPhoto title]];
    [((DSGPhotoInfoViewController*)segue.destinationViewController) setPhoto:selectedPhoto];
}


@end
