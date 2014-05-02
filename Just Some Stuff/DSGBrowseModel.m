//
//  DSGBrowseModel.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 02/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGBrowseModel.h"

@implementation DSGBrowseModel

-(id)init
{
    self = [super init];
    if (self)
    {
        _collectionsData = [NSMutableArray array];
    }
    return self;
}

-(void)fetchDataWithCompletionBlock:(void (^)(BOOL))complection;
{
    FKFlickrCollectionsGetTree *collectionTree = [[FKFlickrCollectionsGetTree alloc] init];
    [collectionTree setUser_id:@"102927591@N02"];
    
    [[FlickrKit sharedFlickrKit] call:collectionTree completion:^(NSDictionary *response, NSError *error) {
        if (response)
        {
            NSMutableArray *collectionTreeArray = [NSMutableArray array];
            for (NSDictionary *collectionData in [response valueForKeyPath:@"collections.collection"])
            {
                //NSURL *url = [[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeSmall320 fromPhotoDictionary:photoData];
                [collectionTreeArray addObject:[[DSGPhotoCollection alloc] initWithDictionary:collectionData]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([collectionTreeArray count] > 1)
                {
                    self.collectionsData = collectionTreeArray;
                    complection(YES);
                }
                else
                {complection(NO);
                    
                }
            });
        }
    }];
}

@end
