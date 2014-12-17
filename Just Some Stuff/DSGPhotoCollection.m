//
//  DSGPhotoCollection.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 18/04/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGPhotoCollection.h"

@implementation DSGPhotoCollection

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        _collection_identifier = [dictionary objectForKey:@"id"];
        _collection_title = [dictionary objectForKey:@"title"];
        _collection_description = [dictionary objectForKey:@"description"];
        _collection_imagesSet = [NSMutableArray array];
    }
    return self;
}

-(void)pareseData:(NSDictionary *)dictionary
{
    for (NSDictionary* photoset in [dictionary objectForKey:@"set"])
    {
        DSGPhotoSet *photoSet = [[DSGPhotoSet alloc] initWithDitctionary:photoset];
        [_collection_imagesSet addObject: photoSet];
    }
}

-(void)parseCoverWithDitction:(NSDictionary *)dict andCompletetion:(void (^)(BOOL))completion
{
    dispatch_group_t taskGroup = dispatch_group_create();
    dispatch_queue_t taskQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
    for (NSDictionary* photoset in [dict objectForKey:@"set"])
    {
        dispatch_group_enter(taskGroup);
        DLog(@"---Enter Group - Photo Collection");
        
        DSGPhotoSet *photoSet = [[DSGPhotoSet alloc] initWithDitctionary:photoset];
        [_collection_imagesSet addObject: photoSet];
        [photoSet getPhotoSetCoverImageWtihCompletionBlock:^(BOOL complete) {
            
            dispatch_group_leave(taskGroup);
        }];
        
        dispatch_group_notify(taskGroup, taskQueue, ^{
            
            DLog(@"Done");
            
            if ([_collection_imagesSet count] > 1)
            {
                //self.featuredTrends = photoSets;
                NSLog(@"---Complete YES - Photo Collection");
                completion(YES);
            }
            else
            {
                NSLog(@"---Complete NO - Photo Collection");
                completion(NO);
            }
        });
    }
}

-(void)parseCoverWithDitction:(NSDictionary *)dict group:(dispatch_group_t)disPatchGroup andCompletetion:(void (^)(BOOL))completion
{
    NSUInteger dictCount = [(NSArray *)[dict objectForKey:@"set"] count];
    
    //dispatch_group_t taskGroup = dispatch_group_create();
    //dispatch_queue_t taskQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    //NSLog(@"Count :%lu", (unsigned long)[(NSArray *)[dict objectForKey:@"set"] count]);
    
    for (NSDictionary* photoset in [dict objectForKey:@"set"])
    {
        //dispatch_group_enter(taskGroup);
        NSLog(@"---Enter Group - Photo Collection");
        
        DSGPhotoSet *photoSet = [[DSGPhotoSet alloc] initWithDitctionary:photoset];
        [_collection_imagesSet addObject: photoSet];
        [photoSet getPhotoSetCoverImageWtihCompletionBlock:^(BOOL complete) {
            
            if ([_collection_imagesSet count] == dictCount)
            {
                //self.featuredTrends = photoSets;
                NSLog(@"---Complete YES - Photo Collection");
                completion(YES);
            }
            else
            {
                NSLog(@"---Complete NO - Photo Collection");
                completion(NO);
            }
            
            NSLog(@"---Leave Group - Photo Collection");
        }];
        
        //        dispatch_group_notify(taskGroup, taskQueue, ^{
        //
        //            if ([_collection_imagesSet count] > 1)
        //            {
        //                //self.featuredTrends = photoSets;
        //                NSLog(@"---Complete YES - Photo Collection");
        //                completion(YES);
        //            }
        //            else
        //            {
        //                NSLog(@"---Complete NO - Photo Collection");
        //                completion(NO);
        //            }
        //        });
    }
}

-(NSURL *)getRandomCoverImageURL
{
    DSGPhotoSet *anyPhotoSet = [[NSSet setWithArray:self.collectionImageSet] anyObject];
    return anyPhotoSet.coverUrl;
}
@end
