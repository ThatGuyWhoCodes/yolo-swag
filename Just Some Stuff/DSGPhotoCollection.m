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
        
        for (NSDictionary* photoset in [dictionary objectForKey:@"set"])
        {
            [_collection_imagesSet addObject:[[DSGPhotoSet alloc] initWithDitctionary:photoset]];
        }
    }
    return self;
}

@end
