//
//  DSGPhotoSet.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 18/04/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGPhotoSet.h"

@implementation DSGPhotoSet

-(instancetype)initWithDitctionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        _set_title = [dictionary objectForKey:@"title"];
        _set_description = [dictionary objectForKey:@"description"];
        _set_identifer = [dictionary objectForKey:@"id"];
        //[self getPhotoSetCoverImage];
    }
    return self;
}

-(void)getPhotoSetCoverImageWtihCompletionBlock:(void (^)(BOOL))completion
{
    FKFlickrPhotosetsGetPhotos *getPhotos = [[FKFlickrPhotosetsGetPhotos alloc] init];
    [getPhotos setPhotoset_id:_set_identifer];

     [[FlickrKit sharedFlickrKit] call:getPhotos completion:^(NSDictionary *response, NSError *error) {
     // Note this is not the main thread!
     
     if (response)
     {
         NSArray *photoData = [[response objectForKey:@"photoset"] objectForKey:@"photo"];
         
         
         NSMutableArray *photoURLS = [NSMutableArray array];
         NSMutableArray *photos = [NSMutableArray array];
             
             for (NSDictionary* pData in photoData)
             {
                 DSGBasicPhoto *currentPhoto = [[DSGBasicPhoto alloc] initWithDictionary:pData];
                 
                 if ([@([[pData valueForKey:@"isprimary"]intValue]) isEqualToNumber:@1])
                 {
                     self.coverUrl = currentPhoto.imageURL;
                 }
                 
                 [photoURLS addObject:currentPhoto.imageURL];
                 [photos addObject:currentPhoto];
             }
             self.photoUrls = photoURLS;
             _photos = photos;
     }
         
    completion(YES);
        
    }];
}

-(NSUInteger)numberOfPhotos
{
    return [self.photoUrls count];
}

-(NSSet *) photoIDSet
{
    NSMutableSet *tempSet = [NSMutableSet set];
    for (DSGBasicPhoto *currentPhoto in self.photos)
    {
        [tempSet addObject:currentPhoto.identification];
    }
    return tempSet;
}

@end
