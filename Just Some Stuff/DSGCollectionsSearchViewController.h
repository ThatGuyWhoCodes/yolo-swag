//
//  DSGCollectionsSearchViewController.h
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 05/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSGAlbumModel.h"

@interface DSGCollectionsSearchViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate, UIScrollViewDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) DSGAlbumModel *albumModel;

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

-(void)setPhotoSet:(DSGPhotoSet *)photoSet;
@end
