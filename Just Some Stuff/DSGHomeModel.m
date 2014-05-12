//
//  DSGHomeModel.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 17/04/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGHomeModel.h"

@implementation DSGHomeModel

+(DSGHomeModel *)sharedInstance
{
    static dispatch_once_t pred;
    static DSGHomeModel *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[DSGHomeModel alloc] init];
        sharedInstance.photoData = [NSMutableArray array];
    });
    return sharedInstance;
}

-(void)clean
{
    [self.photoData removeAllObjects];
}

-(BOOL)setSelectedPhotoUsingIndex:(NSUInteger)index
{
    
    if (!self.photoData)
    {
        return NO;
    }
    
    self.selectedPhoto = [self.photoData objectAtIndex:index];
    return YES;
}

-(void)freshPullWithCompletionBlock:(void (^)(BOOL))complection
{
    FlickrKit *fk = [FlickrKit sharedFlickrKit];
    
    FKFlickrCollectionsGetTree *collectionTree = [[FKFlickrCollectionsGetTree alloc] init];
    [collectionTree setUser_id:@"115055955@N06"];  //TODO: To univeral consts
    
    [fk call:collectionTree completion:^(NSDictionary *response, NSError *error) {
        if (response)
        {
            NSDictionary *featuredCollection = [[response valueForKeyPath:@"collections.collection"] firstObject];
            NSDictionary *photoset = [[featuredCollection objectForKey:@"set"] firstObject];
            FKFlickrPhotosetsGetPhotos *getPhotos = [[FKFlickrPhotosetsGetPhotos alloc] init];
            [getPhotos setPhotoset_id:[photoset objectForKey:@"id"]];
            
            [[FlickrKit sharedFlickrKit] call:getPhotos completion:^(NSDictionary *response, NSError *error) {
                
                NSMutableArray *photoURLs = [NSMutableArray array];
                for (NSDictionary *pData in [response valueForKeyPath:@"photoset.photo"])
                {
                    [photoURLs addObject:[[DSGBasicPhoto alloc] initWithDictionary:pData]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([photoURLs count] > 1)
                    {
                        self.photoData = photoURLs;
                        complection(YES);
                    }
                    else
                    {
                        complection(NO);
                    }
                });
            }];
            
        }
        else
        {
            complection(NO);
        }
    }];
}

@end
