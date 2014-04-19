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
        [self getPhotoSetCoverImage];
    }
    return self;
}

-(void)getPhotoSetCoverImage
{
    FKFlickrPhotosetsGetPhotos *getPhotos = [[FKFlickrPhotosetsGetPhotos alloc] init];
    [getPhotos setPhotoset_id:_set_identifer];
    
     [[FlickrKit sharedFlickrKit] call:getPhotos completion:^(NSDictionary *response, NSError *error) {
     // Note this is not the main thread!
     
     if (response)
     {
         NSArray *photoData = [[response objectForKey:@"photoset"] objectForKey:@"photo"];
         
         dispatch_async(dispatch_get_main_queue(), ^{
             
             NSMutableArray *photoURLS = [NSMutableArray array];
             
             for (NSDictionary* photo in photoData)
             {
                 NSURL *photoURL = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeLarge1024 fromPhotoDictionary:photo];
                 
                 if ([@([[photo valueForKey:@"isprimary"]intValue]) isEqualToNumber:@1])
                 {
                     self.coverUrl = photoURL;
                 }
                 
                 [photoURLS addObject:photoURL];
             }
             self.photoUrls = photoURLS;
            });
            }
        }];
}

@end
