//
//  DSGNestedCollection.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 05/10/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGNestedCollection.h"
#import "DSGPhotoCollection.h"

@implementation DSGNestedCollection

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        _collection_identifier = [dictionary objectForKey:@"id"];
        _collection_title = [dictionary objectForKey:@"title"];
        _collection_description = [dictionary objectForKey:@"description"];
        _collection_cover_image = [NSURL URLWithString:[dictionary objectForKey:@"iconlarge"]];
        _collection_collection = [NSMutableArray array];
    }
    return self;
}

-(void)pareseData:(NSDictionary *)dictionary {
    
    for (NSDictionary *photoCollection in [dictionary objectForKey:@"collection"]) {
        DSGPhotoCollection* collection = [[DSGPhotoCollection alloc] initWithDictionary:photoCollection];
        [collection pareseData:photoCollection];
        [_collection_collection addObject:collection];
    }
}

-(void)parseCoverWithDitction:(NSDictionary *)dict andCompletetion:(void (^)(BOOL))completion
{
    NSUInteger dictCount = [(NSArray *)[dict objectForKey:@"collection"] count];
    
    
    dispatch_group_t taskGroup = dispatch_group_create();
    dispatch_queue_t taskQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    for (NSDictionary* collectionData in [dict objectForKey:@"collection"])
    {
        
        dispatch_group_enter(taskGroup);
        NSLog(@"--Enter - Nested");
        
        DSGPhotoCollection* collection = [[DSGPhotoCollection alloc] initWithDictionary:collectionData];
        [_collection_collection addObject:collection];
        [collection parseCoverWithDitction:collectionData andCompletetion:^(BOOL complete) {
            
            dispatch_group_leave(taskGroup);
            NSLog(@"--Leaving - Nested");
            
        }];
    }
    
    dispatch_group_notify(taskGroup, taskQueue, ^{
        
        DLog(@"Done");
        
        if ([_collection_collection count] == dictCount)
        {
            NSLog(@"--Complete YES - Nested");
            completion(YES);
        }
        else
        {
            NSLog(@"--Complete NO - Nested");
            completion(NO);
        }
    });

}

- (NSURL *)getRandomImageFromAnyCollection
{
    DSGPhotoCollection *anyCollection = [[NSSet setWithArray:self.collectionCollection] anyObject];
    return [anyCollection getRandomCoverImageURL];
}
@end
