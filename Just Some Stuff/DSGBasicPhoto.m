//
//  DSGBasicPhoto.m
//  DsgnrsStudio
//
//  Created by MacBrian Pro on 02/05/2014.
//  Copyright (c) 2014 ThatGuyOrg. All rights reserved.
//

#import "DSGBasicPhoto.h"

@implementation DSGBasicPhoto

-(instancetype)initWithDictionary:(NSDictionary *)photoDictionary
{
    self = [super init];
    if (self)
    {
        [self setTitle:([photoDictionary objectForKey:@"title"]) ? [photoDictionary objectForKey:@"title"] : @"Missing"];
        [self setIdentification:([photoDictionary objectForKey:@"id"]) ? [photoDictionary objectForKey:@"id"] : @""];
        [self setImageURL:[[FlickrKit sharedFlickrKit] photoURLForSize:FKPhotoSizeLarge1024 fromPhotoDictionary:photoDictionary]];
    }
    return self;
}

@end
