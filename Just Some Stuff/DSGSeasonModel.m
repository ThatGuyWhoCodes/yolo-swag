//
//  DSGBrowseModel.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 02/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGSeasonModel.h"
#import "DSGPhotoSet.h"
#import "DSGPhotoCollection.h"
#import "DSGConfig.h"

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

-(NSUInteger) count
{
    return [self.collectionsData count];
}

-(void)fetchDataWithCompletionBlock:(void (^)(BOOL))completion;
{
    FKFlickrCollectionsGetTree *collectionTree = [[FKFlickrCollectionsGetTree alloc] init];
    [collectionTree setUser_id:[DSGConfig userID]];
    
    dispatch_group_t taskGroup = dispatch_group_create();
    dispatch_queue_t taskQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    __weak DSGSeasonModel *weakSelf = self;
    
    [[FlickrKit sharedFlickrKit] call:collectionTree completion:^(NSDictionary *response, NSError *error) {
        if (response)
        {
            NSMutableArray *collectionTreeArray = [NSMutableArray array];
            NSArray *collections = [response valueForKeyPath:@"collections.collection"];

            
            for (NSDictionary *collectionData in collections)
            {
                if (!([collectionData isEqual:[collections firstObject]] || [collectionData isEqual:[collections lastObject]]))
                {
                    
                    DSGNestedCollection* collection = [[DSGNestedCollection alloc] initWithDictionary:collectionData];
                    [collection pareseData:collectionData];
                    [collectionTreeArray addObject:collection];
                }
            }
            
             weakSelf.collectionsData = collectionTreeArray;
            
            for (DSGNestedCollection *currentNest in weakSelf.collectionsData)
            {
                for (DSGPhotoCollection *currentCollection in currentNest.collectionCollection)
                {
                    for (DSGPhotoSet *currentSet in currentCollection.collection_imagesSet)
                    {
                        
                        dispatch_group_enter(taskGroup);
                        
                        [currentSet getPhotoSetCoverImageWtihCompletionBlock:^(BOOL complete) {
                            
                            dispatch_group_leave(taskGroup);
                        }];
                    }
                }
            }
            
            dispatch_group_notify(taskGroup, taskQueue, ^{
                
                if ([collectionTreeArray count] > 0)
                {
                    DLog(@"Finished");
                    completion(YES);
                }
                else
                {
                    DLog(@"Error: %@", error);
                    completion(NO);
                    
                }
            });
            
        }
        else
        {
            DLog(@"Error: %@", error);
            completion(NO);
        }
    }];}

@end
