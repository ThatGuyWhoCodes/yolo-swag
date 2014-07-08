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

-(void)parseCoverWithDitction:(NSDictionary *)dict andCompletetion:(void (^)(BOOL))completion
{
    dispatch_group_t taskGroup = dispatch_group_create();
    dispatch_queue_t taskQueue = dispatch_get_main_queue();
    
    NSLog(@"-Created Tasks");
    
    for (NSDictionary* photoset in [dict objectForKey:@"set"])
    {
        dispatch_group_enter(taskGroup);
        NSLog(@"--Enter Group");
        DSGPhotoSet *photoSet = [[DSGPhotoSet alloc] initWithDitctionary:photoset];
        [photoSet getPhotoSetCoverImageWtihCompletionBlock:^(BOOL complete) {
            dispatch_group_leave(taskGroup);
            NSLog(@"---Exit Group");
        }];
        [_collection_imagesSet addObject: photoSet];
        
        dispatch_group_notify(taskGroup, taskQueue, ^{
            
            if ([_collection_imagesSet count] > 1)
            {
                //self.featuredTrends = photoSets;
                NSLog(@"----Complete YES");
                completion(YES);
            }
            else
            {
                NSLog(@"----Complete NO");
                completion(NO);
            }
        });
    }
}

@end
