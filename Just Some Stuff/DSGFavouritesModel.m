//
//  DSGFavouritesModel.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 27/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGFavouritesModel.h"
#import "DSGPhoto.h"

@interface DSGFavouritesModel ()

@property (nonatomic, strong) DSGBasicPhoto *selectedPhoto;

@end

@implementation DSGFavouritesModel

-(instancetype)initWithFetchedResultsController:(NSFetchedResultsController *)fetched
{
    self = [super init];
    if (self)
    {
        [self initArrayWithFetchedResultsController:fetched];
    }
    return self;
}

-(void)initArrayWithFetchedResultsController:(NSFetchedResultsController *)fetched
{
    NSMutableArray *resultsArray = [NSMutableArray array];
    
    for (DSGPhoto *foundPhoto in [fetched fetchedObjects])
    {
        DSGBasicPhoto *basicPhoto = [[DSGBasicPhoto alloc] init];
        [basicPhoto setTitle:foundPhoto.title];
        [basicPhoto setIdentification:foundPhoto.identification];
        [basicPhoto setImageURL:[NSURL URLWithString:foundPhoto.imageURLString]];
        
        [resultsArray addObject:basicPhoto];
    }
    
    [self setFetechedResults:resultsArray];
}

-(NSInteger)indexOfSlectedPhoto
{
    return [self.fetechedResults indexOfObject:self.selectedPhoto];
}

-(NSUInteger)numberOfPhotos
{
    return [self.fetechedResults count];
}

-(BOOL)setSelectedPhotoAtIndex:(NSUInteger)index
{
    if (!self.fetechedResults)
    {
        return NO;
    }
    
    self.selectedPhoto = [self.fetechedResults objectAtIndex:index];
    return YES;
}

-(NSURL *)photoURLAtIndex:(NSUInteger)index
{
    return [[self.fetechedResults objectAtIndex:index] imageURL];
}

-(DSGBasicPhoto *)getSelectedPhoto
{
    return self.selectedPhoto;
}
@end
