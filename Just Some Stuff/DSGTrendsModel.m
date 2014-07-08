//
//  DSGFeaturedModel.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 12/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGTrendsModel.h"
#import "DSGConfig.h"

@implementation DSGTrendsModel

+(DSGTrendsModel *)sharedInstance
{
    static dispatch_once_t pred;
    static DSGTrendsModel *sharedInstance = nil;
    dispatch_once(&pred, ^{
        sharedInstance = [[DSGTrendsModel alloc] init];
    });
    return sharedInstance;
}

-(void)fetchDataWithCompletionBlock:(void (^)(BOOL))completion
{
    dispatch_group_t taskGroup = dispatch_group_create();
    dispatch_queue_t taskQueue = dispatch_get_main_queue();
    
    FlickrKit *fk = [FlickrKit sharedFlickrKit];
    
    FKFlickrCollectionsGetTree *collectionTree = [[FKFlickrCollectionsGetTree alloc] init];
    [collectionTree setUser_id:[DSGConfig userID]];
    
    [fk call:collectionTree completion:^(NSDictionary *response, NSError *error) {
        if (response)
        {
            NSDictionary *featuredCollection = [[response valueForKeyPath:@"collections.collection"] lastObject];
            
            NSArray *featuredSets = [featuredCollection valueForKeyPath:@"set"];
            
            NSMutableArray *photoSets = [NSMutableArray array];
            for (NSDictionary *setData in featuredSets)
            {
                dispatch_group_enter(taskGroup);
                DSGPhotoSet *photoSet = [[DSGPhotoSet alloc] initWithDitctionary:setData];
                [photoSet getPhotoSetCoverImageWtihCompletionBlock:^(BOOL complete) {
                    dispatch_group_leave(taskGroup);
                }];
                [photoSets addObject:photoSet];
            }
            
            dispatch_group_notify(taskGroup, taskQueue, ^{
                if ([photoSets count] > 1)
                {
                    self.featuredTrends = photoSets;
                    completion(YES);
                }
                else
                {
                    completion(NO);
                }
            });
        }
        else
        {
            completion(NO);
        }
    }];

}

-(NSUInteger)count
{
    return [self.featuredTrends count];
}
@end
