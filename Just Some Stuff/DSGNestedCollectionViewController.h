//
//  DSGNestedCollectionViewController.h
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 05/10/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSGPhotoCollection.h"

@interface DSGNestedCollectionViewController : UICollectionViewController

@property (strong, nonatomic) NSArray *collections;
//@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

-(void)setPhotoCollection:(DSGPhotoCollection *)photoCollection;

@end
