//
//  DSGAlbumModel.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 05/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGAlbumModel.h"

@interface DSGAlbumModel ()

@property (nonatomic, strong) DSGBasicPhoto *selected;

@end

@implementation DSGAlbumModel

-(instancetype)initWithPhotoSet:(DSGPhotoSet *)photoSet
{
    self = [super init];
    if (self)
    {
        _allPhotos = photoSet;
        [self setFilteredPhotos:photoSet.photos];
    }
    return self;
}

-(NSURL *)photoURLAtIndex:(NSUInteger)index
{
     return [[self.filteredPhotos objectAtIndex:index] imageURL];
}

-(NSUInteger)indexOfSlectedPhoto
{
    return [self.filteredPhotos indexOfObject:self.selected];
}

-(DSGBasicPhoto *)getSelectedPhoto
{
    return self.selected;
}

-(BOOL)setSelectedPhotoAtIndex:(NSUInteger)index
{
    self.selected = [self.filteredPhotos objectAtIndex:index];
    return YES;
}

-(NSUInteger)numberOfPhotos
{
    return [self.filteredPhotos count];
}

-(void)reset
{
    [self setFilteredPhotos:self.allPhotos.photos];
}

-(void)searchAblumUsingText:(NSString *)searchText completionBlock:(void (^)(BOOL))complection;
{
    FlickrKit *flickKit = [FlickrKit sharedFlickrKit];
    
    FKFlickrPhotosSearch *searchPhotos = [[FKFlickrPhotosSearch alloc] init];
    [searchPhotos setUser_id:@"115055955@N06"]; //TODO: To univeral consts
    [searchPhotos setText:searchText];
    
    __weak DSGAlbumModel *weakSelf = self;
    
    [flickKit call:searchPhotos completion:^(NSDictionary *response, NSError *error) {
        
        if (response)
        {
            if ([[response objectForKey:@"stat"] isEqualToString:@"ok"] &&  [[response valueForKeyPath:@"photos.total"] integerValue] > 0)
            {
                
                NSMutableArray *tempBasicPhotoArr = [NSMutableArray array];
                for (NSDictionary *pData in [response valueForKeyPath:@"photos.photo"])
                {
                    
                    if ([[self.allPhotos photoIDSet] containsObject:[pData objectForKey:@"id"]])
                    {
                        [tempBasicPhotoArr addObject:[[DSGBasicPhoto alloc] initWithDictionary:pData]];
                        
                    }
                }
                weakSelf.filteredPhotos = tempBasicPhotoArr;
                complection(YES);
            }
            else
            {
                NSLog(@"Error: %@", error);
                complection(NO);
                
            }
        }
        else
        {
            NSLog(@"Error: %@", error);
            complection(NO);
        }
    }];
}

@end
