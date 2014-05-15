//
//  DSGFavouritesViewController.h
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 15/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DSGFavouritesViewController : UICollectionViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, strong) NSFetchedResultsController *photoFetchedResultsController;

@end
