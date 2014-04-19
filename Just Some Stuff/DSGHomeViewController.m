//
//  TGOViewController.m
//  Just Some Stuff
//
//  Created by MacBrian Pro on 30/03/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGHomeViewController.h"
#import "DSGHomeCollectionViewCell.h"

#import "SDWebImage/UIImageView+WebCache.h"

@implementation DSGHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.photoData = [NSMutableArray array];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    FKFlickrPhotosGetRecent *recent = [[FKFlickrPhotosGetRecent alloc] init];
    
    [[FlickrKit sharedFlickrKit] call:recent completion:^(NSDictionary *response, NSError *error) {
        // Note this is not the main thread!
        
        if (response)
        {
            NSMutableArray *photoURLs = [NSMutableArray array];
            for (NSDictionary *photoData in [response valueForKeyPath:@"photos.photo"])
            {
                NSURL *url = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeLarge1024 fromPhotoDictionary:photoData];
                [photoURLs addObject:url];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.photoData = photoURLs;
                [self.collectionView reloadData];
            });
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
    return [self.photoData count];
}

-(DSGHomeCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DSGHomeCollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    
    if (!cell)
    {
        cell = [[DSGHomeCollectionViewCell alloc] init];
    }
    
    [cell.image setContentMode:UIViewContentModeScaleAspectFill];
    [cell.image setImageWithURL:[self.photoData objectAtIndex:indexPath.row] placeholderImage:[UIImage imageNamed:@"IMG_0038.JPG"]];
    
    [cell.label setText:[[self.photoData objectAtIndex:indexPath.row] description]];
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[segue.destinationViewController navigationItem] setTitle:@"Blue"];
}
@end
