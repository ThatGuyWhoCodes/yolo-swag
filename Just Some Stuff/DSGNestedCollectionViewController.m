//
//  DSGNestedCollectionViewController.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 05/10/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGNestedCollectionViewController.h"
#import "DSGPhotoAlbumCollectionViewCell.h"

#import "DSGCollectionsSearchViewController.h"

@interface DSGNestedCollectionViewController ()

@end

@implementation DSGNestedCollectionViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:self.navigationItem.title];
    // Do any additional setup after loading the view.
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setPhotoCollection:(DSGPhotoCollection *)photoCollection
{
    self.collections = photoCollection.collectionImageSet;
}

#pragma mark - UICollectionView Data Source & Delegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.collections count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *collCellID = @"_SET_ITEM_ID_COLLECTION_";
    
    DSGPhotoAlbumCollectionViewCell *collectioViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:collCellID forIndexPath:indexPath];
    
    if (!collectioViewCell)
    {
        collectioViewCell = [[DSGPhotoAlbumCollectionViewCell alloc] init];
    }
    
    DSGPhotoSet *selectedCollection = [self.collections objectAtIndex:indexPath.row];

    
    [collectioViewCell.imageView setImageWithURL:selectedCollection.coverUrl placeholderImage:[DSGUtilities placeholderImage]];
    [collectioViewCell makeStacked];
    
    return collectioViewCell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:(UICollectionViewCell *)sender];
    DSGPhotoSet *selectedPhoto = [self.collections objectAtIndex:indexPath.row];
    
    [[(DSGCollectionsSearchViewController *)segue.destinationViewController navigationItem] setTitle:[[selectedPhoto title] uppercaseString]];
    [(DSGCollectionsSearchViewController *)segue.destinationViewController setPhotoSet:selectedPhoto];
}


@end
