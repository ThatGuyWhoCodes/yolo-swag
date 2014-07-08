//
//  DSGHomeModel.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 17/04/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGHomeModel.h"
#import "DSGConfig.h"

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

#pragma mark - DSGImageCollectionProtocol
-(NSUInteger)numberOfPhotos
{
    return [self.photoData count];
}

-(NSURL *)photoURLAtIndex:(NSUInteger)index
{
    DSGBasicPhoto *photo = [self.photoData objectAtIndex:index];
    return photo.imageURL;
}

-(BOOL)setSelectedPhotoAtIndex:(NSUInteger)index
{
    if (!self.photoData)
    {
        return NO;
    }
    
    self.selectedPhoto = [self.photoData objectAtIndex:index];
    return YES;
}

-(DSGBasicPhoto *)getSelectedPhoto
{
    return self.selectedPhoto;
}

-(NSUInteger)indexOfSlectedPhoto
{
    return [self.photoData indexOfObject:self.selectedPhoto];
}

#pragma mark - Other
-(void)clean
{
    [self.photoData removeAllObjects];
}

-(void)freshPullWithCompletionBlock:(void (^)(BOOL))completion
{
    FlickrKit *fk = [FlickrKit sharedFlickrKit];
    
    FKFlickrCollectionsGetTree *collectionTree = [[FKFlickrCollectionsGetTree alloc] init];
    [collectionTree setUser_id:[DSGConfig userID]]; 
    
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
                        completion(YES);
                    }
                    else
                    {
                        completion(NO);
                    }
                });
            }];
            
        }
        else
        {
            completion(NO);
        }
    }];
}

@end
