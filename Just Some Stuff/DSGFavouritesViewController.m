//
//  DSGFavouritesViewController.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 15/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGFavouritesViewController.h"
#import "DSGFavouriteCollectionViewCell.h"
#import "DSGPhotoInfoViewController.h"
#import "DSGAppDelegate.h"
#import "DSGFavouritesModel.h"
#import "DSGPhoto.h"

static NSString *title = @"FAVOURITES";

@implementation DSGFavouritesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.managedObjectContext = ((DSGAppDelegate *)[[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    //Create fectch request
    NSFetchRequest *fecthRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DSGPhoto" inManagedObjectContext:self.managedObjectContext];
    
    NSSortDescriptor *titleSort = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    
    [fecthRequest setSortDescriptors:@[titleSort]];
    
    [fecthRequest setEntity:entity];
    
    self.photoFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fecthRequest
                                                                             managedObjectContext:self.managedObjectContext
                                                                             sectionNameKeyPath:nil
                                                                             cacheName:nil];
    
    self.photoFetchedResultsController.delegate = self;
    NSError *fecthingError = nil;
    if ([self.photoFetchedResultsController performFetch:&fecthingError])
    {
        NSLog(@"Successly fecthed data");
    }
    else
    {
        NSLog(@"fecthing failed");
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationItem setTitle:[NSString string]];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setTitle:title];
}

#pragma mark - Collection View Data Source
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.photoFetchedResultsController.sections objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}

-(DSGFavouriteCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cell_id = @"_FAVOURTIE_COLLECTION_CELL_ID_";
    
    DSGFavouriteCollectionViewCell *collectionViewCell = [collectionView dequeueReusableCellWithReuseIdentifier:cell_id forIndexPath:indexPath];
    
    if (!collectionViewCell)
    {
        collectionViewCell = [[DSGFavouriteCollectionViewCell alloc] init];
    }
    
    DSGPhoto *photo = [self.photoFetchedResultsController objectAtIndexPath:indexPath];
    
    
    [collectionViewCell.titleLabel setText: photo.title];
    [collectionViewCell.backgroundImageView setImageWithURL:[NSURL URLWithString:photo.imageURLString] placeholderImage:[UIImage imageNamed:@"IMG_0038.JPG"]];
    
    return collectionViewCell;
}

#pragma mark - FetchedResultsController
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.collectionView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexpath = [self.collectionView indexPathForCell:sender];
    
    DSGFavouritesModel *favouritesModel = [[DSGFavouritesModel alloc] initWithFetchedResultsController:self.photoFetchedResultsController];
    [favouritesModel setSelectedPhotoAtIndex:indexpath.row];
    
    DSGBasicPhoto *selectedPhoto = [favouritesModel getSelectedPhoto];
    
    [[segue.destinationViewController navigationItem] setTitle:selectedPhoto.title];
    //[((DSGPhotoInfoViewController*)segue.destinationViewController) setBasicPhoto:selectedPhoto];
    [((DSGPhotoInfoViewController*)segue.destinationViewController) setImageAlbum:favouritesModel];
}


@end
