//
//  DSGAlbumModel.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 05/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGAlbumModel.h"

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

-(NSUInteger)numberOfPhotos
{
    return [self.filteredPhotos count];
}

-(NSURL *)imageURLAtIndex:(NSUInteger)index
{
    return [[self.filteredPhotos objectAtIndex:index] imageURL];
}

-(void)searchAblumUsingText:(NSString *)searchText completionBlock:(void (^)(BOOL))complection;
{
    FlickrKit *flickKit = [FlickrKit sharedFlickrKit];
    
    FKFlickrPhotosSearch *searchPhotos = [[FKFlickrPhotosSearch alloc] init];
    [searchPhotos setUser_id:@"102927591@N02"]; //TODO: To univeral consts
    [searchPhotos setText:searchText];
    
    __weak DSGAlbumModel *weakSelf = self;
    
    [flickKit call:searchPhotos completion:^(NSDictionary *response, NSError *error) {
        
        if (response)
        {
            if ([[response objectForKey:@"stat"] isEqualToString:@"ok"] && [[[response objectForKey:@"photos"] objectForKey:@"total"] integerValue] > 0)
            {
                
                NSMutableArray *tempBasicPhotoArr = [NSMutableArray array];
                for (NSDictionary *pData in [[response objectForKey:@"photos"] objectForKey:@"photo"])
                {
                    
                    if ([[self.allPhotos photoIDSet] containsObject:[pData objectForKey:@"id"]])
                    {
                        NSLog(@"%@", pData);
                        [tempBasicPhotoArr addObject:[[DSGBasicPhoto alloc] initWithDictionary:pData]];
                        
                    }
                }
                weakSelf.filteredPhotos = tempBasicPhotoArr;
                complection(YES);
            }
            else
            {
                complection(NO);
                
            }
        }
        else
        {
            complection(NO);
        }
    }];
}

@end
