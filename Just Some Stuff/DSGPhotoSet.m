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
    }
    return self;
}

@end
