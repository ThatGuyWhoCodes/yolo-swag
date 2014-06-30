//
//  DSGBrowseModel.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 02/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGSeasonModel.h"

@implementation DSGSeasonModel

+(DSGSeasonModel *)sharedInstance
{
    static dispatch_once_t pred;
    static DSGSeasonModel *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[DSGSeasonModel alloc] init];
        sharedInstance.collectionsData = [NSMutableArray array];
    });
    return sharedInstance;
}

-(void)fetchDataWithCompletionBlock:(void (^)(BOOL))complection;
{
    FKFlickrCollectionsGetTree *collectionTree = [[FKFlickrCollectionsGetTree alloc] init];
    [collectionTree setUser_id:@"115055955@N06"];  //TODO: To univeral consts
    
    
    [[FlickrKit sharedFlickrKit] call:collectionTree completion:^(NSDictionary *response, NSError *error) {
        if (response)
        {
            NSMutableArray *collectionTreeArray = [NSMutableArray array];
            NSArray *collections = [response valueForKeyPath:@"collections.collection"];
            for (NSDictionary *collectionData in collections)
            {
                if (!([collectionData isEqual:[collections firstObject]] || [collectionData isEqual:[collections lastObject]]))
                {
                    DSGPhotoCollection* collection = [[DSGPhotoCollection alloc] initWithDictionary:collectionData];
                    [collection parseCoverWithDitction:collectionData andCompletetion:^(BOOL complete) {
                        NSLog(@"+Leaving Group");
                    }];
                    [collectionTreeArray addObject:collection];
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([collectionTreeArray count] > 1)
                {
                    self.collectionsData = collectionTreeArray;
                    complection(YES);
                }
                else
                {
                    NSLog(@"Error: %@", error);
                    complection(NO);
                    
                }
            });
        
        }
        else
        {
            NSLog(@"Error: %@", error);
            complection(NO);
        }
    }];
}

@end
